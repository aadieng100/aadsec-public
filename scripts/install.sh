#!/usr/bin/env bash
#
# install.sh -- install AADSec and aadsec-agent on macOS/Linux.
#
# Quick one-liner:
#   curl -fsSL https://github.com/aadieng100/aadsec-public/releases/download/v0.2.0/install.sh | sh
#
# Or download, inspect, and run locally:
#   curl -fsSLO https://github.com/aadieng100/aadsec-public/releases/download/v0.2.0/install.sh
#   sh install.sh
#
# Configuration (environment variables, all optional):
#   AADSEC_VERSION         version to install             (default: 0.2.0)
#   AADSEC_BASE_URL        base URL for release assets    (default: GitHub release)
#   AADSEC_INSTALL_DIR     install directory              (default: ~/.local/bin)
#   AADSEC_SKIP_AGENT      set to 1 to skip aadsec-agent  (default: 0)
#   AADSEC_REQUIRE_AGENT   set to 1 to fail if agent miss (default: 0)
#   AADSEC_NO_MODIFY_PATH  set to 1 to skip PATH updates  (default: 0)
#   AADSEC_NO_COMPLETION   set to 1 to skip completions   (default: 0)
#   AADSEC_SKIP_IMAGE_PULL set to 1 to skip docker pull   (default: 0)
#   AADSEC_RUNNER_IMAGE    runner image reference         (default: ghcr.io/aadieng100/aadsec-runner:<ver>)
set -eu

DEFAULT_VERSION="0.2.0"

TMP_DIR=""
STAGE_CLI=""
STAGE_AGENT=""
STAGE_TMP=""

cleanup() {
	[ -n "${STAGE_CLI:-}" ] && rm -f "${STAGE_CLI}" 2>/dev/null || true
	[ -n "${STAGE_AGENT:-}" ] && rm -f "${STAGE_AGENT}" 2>/dev/null || true
	[ -n "${STAGE_TMP:-}" ] && rm -f "${STAGE_TMP}" 2>/dev/null || true
	[ -n "${TMP_DIR:-}" ] && rm -rf "${TMP_DIR}" 2>/dev/null || true
}
trap cleanup EXIT INT TERM HUP

info() { printf '%s\n' "$*"; }
warn() { printf 'WARNING: %s\n' "$*" >&2; }
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }

usage() {
	cat <<'EOF'
Usage: install.sh [VERSION]

Install AADSec CLI (aadsec) and companion agent (aadsec-agent) on macOS/Linux.

Environment variables:
  AADSEC_VERSION         Version to install (default: 0.2.0)
  AADSEC_BASE_URL        Base URL or local directory for assets
  AADSEC_INSTALL_DIR     Target directory (default: ~/.local/bin)
  AADSEC_SKIP_AGENT      Set to 1 to skip installing aadsec-agent
  AADSEC_REQUIRE_AGENT   Set to 1 to fail if aadsec-agent is missing from SHA256SUMS
  AADSEC_NO_MODIFY_PATH  Set to 1 to skip shell profile PATH updates
  AADSEC_NO_COMPLETION   Set to 1 to skip shell completion generation
  AADSEC_SKIP_IMAGE_PULL Set to 1 to skip pulling the Docker runner image
  AADSEC_RUNNER_IMAGE    Runner Docker image reference
EOF
}

download() {
	url="$1"
	dest="$2"
	case "${url}" in
		file://*|/*)
			src="${url#file://}"
			[ -f "${src}" ] || die "local source not found: ${src}"
			cp "${src}" "${dest}"
			;;
		https://*)
			if command -v curl >/dev/null 2>&1; then
				if curl --help all 2>/dev/null | grep -q -- '--proto'; then
					curl -fsSL --proto '=https' --tlsv1.2 "${url}" -o "${dest}"
				else
					curl -fsSL "${url}" -o "${dest}"
				fi
			elif command -v wget >/dev/null 2>&1; then
				if wget --help 2>&1 | grep -q -- '--https-only'; then
					wget -q --https-only "${url}" -O "${dest}"
				else
					wget -q "${url}" -O "${dest}"
				fi
			else
				die "need 'curl' or 'wget' to download; please install one."
			fi
			;;
		*)
			if command -v curl >/dev/null 2>&1; then
				curl -fsSL "${url}" -o "${dest}"
			elif command -v wget >/dev/null 2>&1; then
				wget -q "${url}" -O "${dest}"
			else
				die "need 'curl' or 'wget' to download; please install one."
			fi
			;;
	esac
}

lookup_expected_sha256() {
	asset="$1"
	sums_file="${TMP_DIR}/SHA256SUMS"
	awk_status=0
	res="$(awk -v target="${asset}" '
		{
			if ($0 == "") next
			f2 = $2
			len_t = length(target)
			len_f2 = length(f2)
			is_sub = (len_f2 > len_t && substr(f2, len_f2 - len_t) == "/" target)
			if (f2 == target || f2 == "*" target || is_sub) {
				if ($0 !~ /^[0-9a-fA-F]{64}  [^ *]+$/ || NF != 2 || f2 != target) {
					exit 2
				}
				count++
				hash = tolower($1)
			}
		}
		END {
			if (count > 1) exit 3
			if (count == 1) printf "%s", hash
		}
	' "${sums_file}")" || awk_status=$?
	if [ "${awk_status}" -eq 2 ]; then
		die "malformed checksum line for ${asset} in SHA256SUMS — refusing to install."
	elif [ "${awk_status}" -eq 3 ]; then
		die "duplicate checksum entries for ${asset} in SHA256SUMS — refusing to install."
	elif [ "${awk_status}" -ne 0 ]; then
		die "failed to parse SHA256SUMS for ${asset}."
	fi
	printf '%s' "${res}"
}

sha256_of() {
	target_file="$1"
	if command -v sha256sum >/dev/null 2>&1; then
		sha_out="$(sha256sum "${target_file}")" || die "sha256sum failed on ${target_file}"
	elif command -v shasum >/dev/null 2>&1; then
		sha_out="$(shasum -a 256 "${target_file}")" || die "shasum failed on ${target_file}"
	else
		die "need 'sha256sum' or 'shasum' to verify integrity."
	fi
	set -- ${sha_out}
	hash_lc="$(printf '%s' "$1" | tr 'A-F' 'a-f')"
	awk 'BEGIN { if (ARGV[1] !~ /^[0-9a-f]{64}$/) exit 1 }' "${hash_lc}" || die "unexpected sha256 output for ${target_file}"
	printf '%s' "${hash_lc}"
}

write_completion_atomic() {
	bin_path="$1"
	shell_name="$2"
	dest_path="$3"
	dest_dir="$(dirname "${dest_path}")"

	if [ -L "${dest_path}" ] || [ -d "${dest_path}" ]; then
		warn "refusing to overwrite non-regular path ${dest_path} for shell completion."
		return 0
	fi
	if "${bin_path}" completion "${shell_name}" > "${TMP_DIR}/comp.out" 2>/dev/null && [ -s "${TMP_DIR}/comp.out" ]; then
		comp_tmp="$(mktemp "${dest_dir}/.comp.XXXXXX")"
		STAGE_TMP="${comp_tmp}"
		cp "${TMP_DIR}/comp.out" "${comp_tmp}"
		chmod 644 "${comp_tmp}" 2>/dev/null || true
		if [ -L "${dest_path}" ]; then
			rm -f "${comp_tmp}" 2>/dev/null || true
			STAGE_TMP=""
			warn "refusing to overwrite symlink ${dest_path}."
			return 0
		fi
		mv -f "${comp_tmp}" "${dest_path}"
		STAGE_TMP=""
	fi
}

update_rc_file() {
	rc_file="$1"
	block_file="$2"
	rc_dir="$(dirname "${rc_file}")"

	if [ -L "${rc_dir}" ] || [ -L "${rc_file}" ] || ( [ -e "${rc_file}" ] && [ ! -f "${rc_file}" ] ); then
		warn "refusing to modify symlink or non-regular profile ${rc_file}."
		return 0
	fi

	if [ ! -d "${rc_dir}" ]; then
		mkdir -p "${rc_dir}" 2>/dev/null || { warn "cannot create directory ${rc_dir}; skipping ${rc_file}."; return 0; }
	fi

	if [ -f "${rc_file}" ]; then
		rc_check="$(awk '
			$0 == "# >>> aadsec initialize >>>" { open_cnt++; if (open_line == 0) open_line = NR }
			$0 == "# <<< aadsec initialize <<<" { close_cnt++; if (close_line == 0) close_line = NR }
			END { printf "%d %d %d %d", open_cnt+0, close_cnt+0, open_line+0, close_line+0 }
		' "${rc_file}")"
		set -- ${rc_check}
		open_cnt="$1"
		close_cnt="$2"
		open_line="$3"
		close_line="$4"
		if [ "${open_cnt}" -ne "${close_cnt}" ] || [ "${open_cnt}" -gt 1 ] || ( [ "${open_cnt}" -eq 1 ] && [ "${open_line}" -ge "${close_line}" ] ); then
			warn "malformed aadsec block in ${rc_file}; skipping profile update to preserve file content."
			return 0
		fi

		rc_tmp="$(mktemp "${rc_dir}/.aadsec-rc.XXXXXX")"
		STAGE_TMP="${rc_tmp}"
		cp -p "${rc_file}" "${rc_tmp}" 2>/dev/null || true
		if [ "${open_cnt}" -eq 1 ]; then
			awk -v bf="${block_file}" '
				$0 == "# >>> aadsec initialize >>>" {
					while ((getline line < bf) > 0) print line
					close(bf)
					in_block = 1
					next
				}
				in_block && $0 == "# <<< aadsec initialize <<<" {
					in_block = 0
					next
				}
				!in_block { print }
			' "${rc_file}" > "${rc_tmp}"
		else
			cp "${rc_file}" "${rc_tmp}"
			if [ -s "${rc_file}" ] && [ "$(tail -c 1 "${rc_file}" | wc -l)" -eq 0 ]; then
				printf '\n' >> "${rc_tmp}"
			fi
			cat "${block_file}" >> "${rc_tmp}"
		fi
		chmod --reference="${rc_file}" "${rc_tmp}" 2>/dev/null || true
	else
		rc_tmp="$(mktemp "${rc_dir}/.aadsec-rc.XXXXXX")"
		STAGE_TMP="${rc_tmp}"
		cp "${block_file}" "${rc_tmp}"
		chmod 644 "${rc_tmp}" 2>/dev/null || true
	fi

	if [ -L "${rc_file}" ]; then
		rm -f "${rc_tmp}" 2>/dev/null || true
		STAGE_TMP=""
		warn "refusing to overwrite symlink ${rc_file}."
		return 0
	fi
	mv -f "${rc_tmp}" "${rc_file}"
	STAGE_TMP=""
}

main() {
	if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
		usage
		exit 0
	fi

	VERSION="${AADSEC_VERSION:-${1:-$DEFAULT_VERSION}}"
	BASE_URL="${AADSEC_BASE_URL:-https://github.com/aadieng100/aadsec-public/releases/download/v${VERSION}}"
	INSTALL_DIR="${AADSEC_INSTALL_DIR:-${HOME}/.local/bin}"
	SKIP_AGENT="${AADSEC_SKIP_AGENT:-0}"
	REQUIRE_AGENT="${AADSEC_REQUIRE_AGENT:-0}"
	NO_MODIFY_PATH="${AADSEC_NO_MODIFY_PATH:-0}"
	NO_COMPLETION="${AADSEC_NO_COMPLETION:-0}"
	SKIP_IMAGE_PULL="${AADSEC_SKIP_IMAGE_PULL:-0}"
	RUNNER_IMAGE="${AADSEC_RUNNER_IMAGE:-ghcr.io/aadieng100/aadsec-runner:${VERSION}}"

	case "${VERSION}" in
		""|*[!0-9A-Za-z._-]*|[!0-9A-Za-z]*|*..* )
			die "invalid version '${VERSION}'."
			;;
	esac

	BASE_URL="${BASE_URL%/}"
	[ -n "${BASE_URL}" ] || die "AADSEC_BASE_URL must not be empty."

	[ -n "${INSTALL_DIR}" ] || die "AADSEC_INSTALL_DIR must not be empty."
	while [ "${INSTALL_DIR}" != "/" ] && [ "${INSTALL_DIR%/}" != "${INSTALL_DIR}" ]; do
		INSTALL_DIR="${INSTALL_DIR%/}"
	done
	if [ -z "${INSTALL_DIR}" ] || [ "${INSTALL_DIR}" = "/" ]; then
		die "invalid install directory '${INSTALL_DIR}'."
	fi
	if [ -L "${INSTALL_DIR}" ]; then
		die "refusing to install into symlink directory '${INSTALL_DIR}'."
	fi
	if [ -e "${INSTALL_DIR}" ] && [ ! -d "${INSTALL_DIR}" ]; then
		die "install path '${INSTALL_DIR}' exists and is not a directory."
	fi

	case "${RUNNER_IMAGE}" in
		""|-*|*[!0-9A-Za-z._:/@-]* )
			die "invalid runner image '${RUNNER_IMAGE}'."
			;;
	esac

	os_raw="$(uname -s)"
	case "${os_raw}" in
		Darwin) os="darwin" ;;
		Linux)  os="linux" ;;
		*) die "unsupported OS '${os_raw}'. On Windows, use scripts/install.ps1 (PowerShell)." ;;
	esac

	arch_raw="$(uname -m)"
	case "${arch_raw}" in
		x86_64|amd64)  arch="amd64" ;;
		arm64|aarch64) arch="arm64" ;;
		*) die "unsupported architecture '${arch_raw}'." ;;
	esac

	ASSET_CLI="aadsec_${VERSION}_${os}_${arch}"
	ASSET_AGENT="aadsec-agent_${VERSION}_${os}_${arch}"
	info "-> Installing AADSec ${VERSION} for ${os}/${arch}"

	tmp_base="${TMPDIR:-/tmp}"
	tmp_base="${tmp_base%/}"
	[ -n "${tmp_base}" ] || tmp_base="/tmp"
	TMP_DIR="$(mktemp -d "${tmp_base}/aadsec-install.XXXXXX")"

	info "-> Downloading SHA256SUMS..."
	download "${BASE_URL}/SHA256SUMS" "${TMP_DIR}/SHA256SUMS" || die "failed to download ${BASE_URL}/SHA256SUMS"
	[ -s "${TMP_DIR}/SHA256SUMS" ] || die "SHA256SUMS is empty — refusing to install."
	if tr -d '\015' < "${TMP_DIR}/SHA256SUMS" | cmp -s - "${TMP_DIR}/SHA256SUMS"; then
		:
	else
		die "SHA256SUMS contains CR characters — refusing to install."
	fi

	expected_cli="$(lookup_expected_sha256 "${ASSET_CLI}")"
	[ -n "${expected_cli}" ] || die "no checksum entry for ${ASSET_CLI} in SHA256SUMS — refusing to install."

	info "-> Downloading and checking ${ASSET_CLI}..."
	download "${BASE_URL}/${ASSET_CLI}" "${TMP_DIR}/${ASSET_CLI}" || die "failed to download ${BASE_URL}/${ASSET_CLI}"
	actual_cli="$(sha256_of "${TMP_DIR}/${ASSET_CLI}")"
	if [ "${expected_cli}" != "${actual_cli}" ]; then
		die "checksum mismatch for ${ASSET_CLI}! expected=${expected_cli} actual=${actual_cli}"
	fi
	info "OK Checksum verified for ${ASSET_CLI} (SHA256: ${actual_cli})"

	INSTALL_AGENT=0
	if [ "${SKIP_AGENT}" != "1" ]; then
		expected_agent="$(lookup_expected_sha256 "${ASSET_AGENT}")"
		if [ -n "${expected_agent}" ]; then
			info "-> Downloading and checking ${ASSET_AGENT}..."
			download "${BASE_URL}/${ASSET_AGENT}" "${TMP_DIR}/${ASSET_AGENT}" || die "failed to download ${BASE_URL}/${ASSET_AGENT}"
			actual_agent="$(sha256_of "${TMP_DIR}/${ASSET_AGENT}")"
			if [ "${expected_agent}" != "${actual_agent}" ]; then
				die "checksum mismatch for ${ASSET_AGENT}! expected=${expected_agent} actual=${actual_agent}"
			fi
			info "OK Checksum verified for ${ASSET_AGENT} (SHA256: ${actual_agent})"
			INSTALL_AGENT=1
		else
			if [ "${REQUIRE_AGENT}" = "1" ]; then
				die "no checksum entry for ${ASSET_AGENT} in SHA256SUMS — refusing to install."
			fi
			warn "${ASSET_AGENT} not listed in SHA256SUMS; installing aadsec CLI only."
		fi
	fi

	mkdir -p "${INSTALL_DIR}" || die "cannot create install dir ${INSTALL_DIR}"
	if [ -L "${INSTALL_DIR}" ]; then
		die "refusing to install into symlink directory '${INSTALL_DIR}'."
	fi
	INSTALL_DIR="$(cd "${INSTALL_DIR}" && pwd)"

	if [ -d "${INSTALL_DIR}/aadsec" ] || [ -L "${INSTALL_DIR}/aadsec" ]; then
		die "target path '${INSTALL_DIR}/aadsec' is a directory or symlink — refusing to overwrite."
	fi
	STAGE_CLI="$(mktemp "${INSTALL_DIR}/.aadsec.tmp.XXXXXX")"
	cp "${TMP_DIR}/${ASSET_CLI}" "${STAGE_CLI}"
	chmod 755 "${STAGE_CLI}" 2>/dev/null || true
	mv -f "${STAGE_CLI}" "${INSTALL_DIR}/aadsec"
	STAGE_CLI=""
	info "OK Installed aadsec to ${INSTALL_DIR}/aadsec"

	if [ "${INSTALL_AGENT}" = "1" ]; then
		if [ -d "${INSTALL_DIR}/aadsec-agent" ] || [ -L "${INSTALL_DIR}/aadsec-agent" ]; then
			die "target path '${INSTALL_DIR}/aadsec-agent' is a directory or symlink — refusing to overwrite."
		fi
		STAGE_AGENT="$(mktemp "${INSTALL_DIR}/.aadsec-agent.tmp.XXXXXX")"
		cp "${TMP_DIR}/${ASSET_AGENT}" "${STAGE_AGENT}"
		chmod 755 "${STAGE_AGENT}" 2>/dev/null || true
		mv -f "${STAGE_AGENT}" "${INSTALL_DIR}/aadsec-agent"
		STAGE_AGENT=""
		info "OK Installed aadsec-agent to ${INSTALL_DIR}/aadsec-agent"
	fi

	if [ "${NO_COMPLETION}" != "1" ]; then
		aadsec_home="${HOME}/.aadsec"
		comp_dir="${aadsec_home}/completions"
		if [ -L "${aadsec_home}" ] || [ -L "${comp_dir}" ] || ( [ -e "${aadsec_home}" ] && [ ! -d "${aadsec_home}" ] ) || ( [ -e "${comp_dir}" ] && [ ! -d "${comp_dir}" ] ); then
			warn "refusing to write shell completions into symlink or non-directory ${comp_dir}."
		else
			mkdir -p "${comp_dir}"
			chmod 700 "${aadsec_home}" 2>/dev/null || true

			write_completion_atomic "${INSTALL_DIR}/aadsec" "bash" "${comp_dir}/aadsec.bash"
			write_completion_atomic "${INSTALL_DIR}/aadsec" "zsh"  "${comp_dir}/aadsec.zsh"
			write_completion_atomic "${INSTALL_DIR}/aadsec" "fish" "${comp_dir}/aadsec.fish"

			if [ "${INSTALL_AGENT}" = "1" ]; then
				write_completion_atomic "${INSTALL_DIR}/aadsec-agent" "bash" "${comp_dir}/aadsec-agent.bash"
				write_completion_atomic "${INSTALL_DIR}/aadsec-agent" "zsh"  "${comp_dir}/aadsec-agent.zsh"
				write_completion_atomic "${INSTALL_DIR}/aadsec-agent" "fish" "${comp_dir}/aadsec-agent.fish"
			fi

			loader_dest="${comp_dir}/aadsec.sh"
			if [ -L "${loader_dest}" ] || [ -d "${loader_dest}" ]; then
				warn "refusing to overwrite non-regular path ${loader_dest}."
			else
				loader_tmp="$(mktemp "${comp_dir}/.loader.XXXXXX")"
				STAGE_TMP="${loader_tmp}"
				cat > "${loader_tmp}" <<'EOF'
# AADSec shell completion loader
if [ -n "${ZSH_VERSION:-}" ]; then
    if ! command -v compdef >/dev/null 2>&1 && ! type compdef >/dev/null 2>&1; then
        autoload -Uz compinit >/dev/null 2>&1 && compinit -C >/dev/null 2>&1 || true
    fi
    if command -v compdef >/dev/null 2>&1 || type compdef >/dev/null 2>&1; then
        if [ -f "$HOME/.aadsec/completions/aadsec.zsh" ]; then . "$HOME/.aadsec/completions/aadsec.zsh"; fi
        if [ -f "$HOME/.aadsec/completions/aadsec-agent.zsh" ]; then . "$HOME/.aadsec/completions/aadsec-agent.zsh"; fi
    fi
elif [ -n "${BASH_VERSION:-}" ]; then
    if [ -f "$HOME/.aadsec/completions/aadsec.bash" ]; then . "$HOME/.aadsec/completions/aadsec.bash"; fi
    if [ -f "$HOME/.aadsec/completions/aadsec-agent.bash" ]; then . "$HOME/.aadsec/completions/aadsec-agent.bash"; fi
fi
EOF
				chmod 644 "${loader_tmp}" 2>/dev/null || true
				if [ ! -L "${loader_dest}" ]; then
					mv -f "${loader_tmp}" "${loader_dest}"
				else
					rm -f "${loader_tmp}" 2>/dev/null || true
				fi
				STAGE_TMP=""
			fi

			xdg_cfg="${XDG_CONFIG_HOME:-${HOME}/.config}"
			fish_cfg="${xdg_cfg}/fish"
			fish_wanted=0
			if [ -d "${fish_cfg}" ] && [ ! -L "${fish_cfg}" ]; then
				fish_wanted=1
			else
				case "${SHELL:-}" in
					*fish*) fish_wanted=1 ;;
				esac
			fi
			if [ "${fish_wanted}" -eq 1 ]; then
				if [ -L "${xdg_cfg}" ] || [ -L "${fish_cfg}" ] || [ -L "${fish_cfg}/completions" ]; then
					warn "refusing to write fish completions through symlink."
				else
					mkdir -p "${fish_cfg}/completions" 2>/dev/null || true
					if [ -d "${fish_cfg}/completions" ]; then
						write_completion_atomic "${INSTALL_DIR}/aadsec" "fish" "${fish_cfg}/completions/aadsec.fish"
						if [ "${INSTALL_AGENT}" = "1" ]; then
							write_completion_atomic "${INSTALL_DIR}/aadsec-agent" "fish" "${fish_cfg}/completions/aadsec-agent.fish"
						fi
					fi
				fi
			fi

			if [ "${NO_MODIFY_PATH}" = "1" ]; then
				info "Note: shell completion scripts generated in ~/.aadsec/completions/aadsec.sh"
			fi
		fi
	fi

	if [ "${NO_MODIFY_PATH}" != "1" ]; then
		path_safe=0
		case "${INSTALL_DIR}" in
			/*)
				case "${INSTALL_DIR}" in
					*[!A-Za-z0-9._/@+-]*)
						warn "install directory '${INSTALL_DIR}' contains unsupported characters for shell profile update; skipping PATH modification."
						;;
					*)
						path_safe=1
						;;
				esac
				;;
			*)
				warn "install directory '${INSTALL_DIR}' is not an absolute path; skipping PATH modification."
				;;
		esac

		if [ "${path_safe}" -eq 1 ]; then
			home_clean="${HOME%/}"
			INSTALL_DIR_EXPR="${INSTALL_DIR}"
			case "${home_clean}" in
				/*)
					case "${home_clean}" in
						*[!A-Za-z0-9._/@+-]*) : ;;
						*)
							case "${INSTALL_DIR}" in
								"${home_clean}/"*)
									rel_dir="${INSTALL_DIR#"${home_clean}/"}"
									INSTALL_DIR_EXPR="\$HOME/${rel_dir}"
									;;
							esac
							;;
					esac
					;;
			esac

			block_file="${TMP_DIR}/aadsec-block.txt"
			cat > "${block_file}" <<EOF
# >>> aadsec initialize >>>
case ":\$PATH:" in
    *":${INSTALL_DIR_EXPR}:"*) ;;
    *) export PATH="${INSTALL_DIR_EXPR}:\$PATH" ;;
esac
if [ -f "\$HOME/.aadsec/completions/aadsec.sh" ]; then . "\$HOME/.aadsec/completions/aadsec.sh"; fi
# <<< aadsec initialize <<<
EOF

			zdot_rc="${ZDOTDIR:-${HOME}}/.zshrc"
			do_zsh=0
			case "${SHELL:-}" in *zsh*) do_zsh=1 ;; esac
			[ -f "${zdot_rc}" ] && do_zsh=1
			[ "${os}" = "darwin" ] && do_zsh=1
			if [ "${do_zsh}" -eq 1 ]; then
				update_rc_file "${zdot_rc}" "${block_file}"
			fi

			bash_rc="${HOME}/.bashrc"
			do_bash=0
			case "${SHELL:-}" in *bash*) do_bash=1 ;; esac
			[ -f "${bash_rc}" ] && do_bash=1
			[ "${os}" = "linux" ] && do_bash=1
			if [ "${do_bash}" -eq 1 ]; then
				update_rc_file "${bash_rc}" "${block_file}"
			fi

			if [ -f "${HOME}/.bash_profile" ]; then
				update_rc_file "${HOME}/.bash_profile" "${block_file}"
			fi

			update_rc_file "${HOME}/.profile" "${block_file}"

			xdg_cfg="${XDG_CONFIG_HOME:-${HOME}/.config}"
			fish_cfg="${xdg_cfg}/fish"
			fish_wanted=0
			if [ -d "${fish_cfg}" ] && [ ! -L "${fish_cfg}" ]; then
				fish_wanted=1
			else
				case "${SHELL:-}" in
					*fish*) fish_wanted=1 ;;
				esac
			fi
			if [ "${fish_wanted}" -eq 1 ]; then
				if [ -L "${xdg_cfg}" ] || [ -L "${fish_cfg}" ] || [ -L "${fish_cfg}/conf.d" ]; then
					warn "refusing to write fish PATH configuration through symlink."
				else
					mkdir -p "${fish_cfg}/conf.d" 2>/dev/null || true
					fish_conf="${fish_cfg}/conf.d/aadsec.fish"
					if [ -L "${fish_conf}" ] || [ -d "${fish_conf}" ]; then
						warn "refusing to overwrite non-regular path ${fish_conf}."
					elif [ -d "${fish_cfg}/conf.d" ]; then
						fish_tmp="$(mktemp "${fish_cfg}/conf.d/.aadsec.fish.XXXXXX")"
						STAGE_TMP="${fish_tmp}"
						cat > "${fish_tmp}" <<EOF
# >>> aadsec initialize >>>
if not contains -- "${INSTALL_DIR}" \$PATH
    set -gx PATH "${INSTALL_DIR}" \$PATH
end
# <<< aadsec initialize <<<
EOF
						chmod 644 "${fish_tmp}" 2>/dev/null || true
						if [ ! -L "${fish_conf}" ]; then
							mv -f "${fish_tmp}" "${fish_conf}"
						else
							rm -f "${fish_tmp}" 2>/dev/null || true
						fi
						STAGE_TMP=""
					fi
				fi
			fi
		fi
	fi

	if [ "${SKIP_IMAGE_PULL}" != "1" ]; then
		if ! command -v docker >/dev/null 2>&1; then
			info "Note: Docker is not installed. Install Docker before running 'aadsec scan', then pull ${RUNNER_IMAGE}."
		elif ! docker info >/dev/null 2>&1; then
			info "Note: Docker daemon is not running or not accessible. Start Docker, then run: docker pull ${RUNNER_IMAGE}"
		elif docker image inspect "${RUNNER_IMAGE}" >/dev/null 2>&1; then
			info "✓ Runner image ${RUNNER_IMAGE} is already available locally"
		else
			info "→ Pulling runner image ${RUNNER_IMAGE}…"
			if docker pull "${RUNNER_IMAGE}"; then
				info "✓ Pulled runner image ${RUNNER_IMAGE}"
			else
				warn "could not pull ${RUNNER_IMAGE} (offline or registry unreachable). Pull it later with: docker pull ${RUNNER_IMAGE}"
			fi
		fi
	fi

	info ""
	info "Done. Open a new shell or reload your profile, then verify with: aadsec --version"
}

main "$@"
