# DRAFT — THIRD-PARTY SOFTWARE NOTICES AND LICENSES

**STATUS: DRAFT — FOR REVIEW ONLY — NOT A FINAL LEGAL DOCUMENT**

This document contains third-party software notices, licenses, and source code offers
for open-source components incorporated into or redistributed alongside the AADSec CLI
and its container runner image (`ghcr.io/aadieng100/aadsec-runner`).

---

## 1. Go Runtime Dependencies (CLI & Runner Binaries)

The following Go modules are compiled directly into the `aadsec` and `aadsec-runner` binaries:

| Module | Version | License | Upstream URL |
| :--- | :--- | :--- | :--- |
| `github.com/spf13/cobra` | v1.8.1 | Apache-2.0 | https://github.com/spf13/cobra |
| `github.com/spf13/pflag` | v1.0.5 | BSD-3-Clause | https://github.com/spf13/pflag |
| `github.com/inconshreveable/mousetrap` | v1.1.0 | Apache-2.0 | https://github.com/inconshreveable/mousetrap |
| `github.com/cpuguy83/go-md2man/v2` | v2.0.4 | MIT | https://github.com/cpuguy83/go-md2man |
| `github.com/russross/blackfriday/v2` | v2.1.0 | BSD-2-Clause | https://github.com/russross/blackfriday |
| `gopkg.in/yaml.v3` | v3.0.1 | MIT / Apache-2.0 | https://github.com/go-yaml/yaml |
| `gopkg.in/check.v1` | v0.0.0-20161208181325-20d25e280405 | BSD-2-Clause | https://github.com/go-check/check |

---

## 2. Core Security Scanners (Container Runner Image)

The AADSec container runner image orchestrates the following standalone security tools:

| Tool | Version | License | Upstream Repository |
| :--- | :--- | :--- | :--- |
| **Gitleaks** | 8.30.1 | MIT | https://github.com/gitleaks/gitleaks |
| **Trivy** | 0.74.0 | Apache-2.0 | https://github.com/aquasecurity/trivy |
| **Semgrep CE** | 1.80.0 | LGPL-2.1 | https://github.com/semgrep/semgrep |
| **Checkov** | 3.3.19 | Apache-2.0 | https://github.com/bridgecrewio/checkov |

---

## 3. Alpine Linux System Packages (Alpine 3.24 Runtime — 47 Packages)

The runner image runs on an Alpine Linux 3.24 base (`VERSION_ID=3.24.2`). The following 47 packages are installed via `apk`:

| Package | Version | License (SPDX) | Official Upstream / Aport Source |
| :--- | :--- | :--- | :--- |
| `alpine-baselayout` | 3.7.2-r1 | GPL-2.0-only | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/alpine-baselayout |
| `alpine-baselayout-data` | 3.7.2-r1 | GPL-2.0-only | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/alpine-baselayout |
| `alpine-keys` | 2.6-r0 | MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/alpine-keys |
| `alpine-release` | 3.24.2-r0 | MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/alpine-release |
| `apk-tools` | 3.0.8-r0 | GPL-2.0-only | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/apk-tools |
| `brotli-libs` | 1.2.0-r1 | MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/brotli |
| `busybox` | 1.37.0-r31 | GPL-2.0-only | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/busybox |
| `busybox-binsh` | 1.37.0-r31 | GPL-2.0-only | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/busybox |
| `c-ares` | 1.34.8-r0 | MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/c-ares |
| `ca-certificates` | 20260909-r0 | MPL-2.0 AND MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/ca-certificates |
| `ca-certificates-bundle` | 20260909-r0 | MPL-2.0 AND MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/ca-certificates |
| `gdbm` | 1.26-r0 | GPL-3.0-or-later | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/gdbm |
| `git` | 2.54.0-r0 | GPL-2.0-only | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/git |
| `git-init-template` | 2.54.0-r0 | GPL-2.0-only | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/git |
| `libapk` | 3.0.8-r0 | GPL-2.0-only | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/apk-tools |
| `libbz2` | 1.0.8-r6 | bzip2-1.0.6 | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/bzip2 |
| `libcrypto3` | 3.5.8-r0 | Apache-2.0 | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/openssl |
| `libcurl` | 8.22.0-r0 | curl (MIT-like) | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/curl |
| `libexpat` | 2.8.5-r0 | MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/expat |
| `libffi` | 3.5.2-r1 | MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/libffi |
| `libgcc` | 15.2.0-r5 | GPL-3.0-or-later WITH GCC-exception-3.1 | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/gcc |
| `libidn2` | 2.3.8-r0 | GPL-2.0-or-later OR LGPL-3.0-or-later | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/libidn2 |
| `libncursesw` | 6.6_p20260516-r0 | X11 (MIT-like) | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/ncurses |
| `libpanelw` | 6.6_p20260516-r0 | X11 (MIT-like) | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/ncurses |
| `libpsl` | 0.21.5-r3 | MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/libpsl |
| `libssl3` | 3.5.8-r0 | Apache-2.0 | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/openssl |
| `libstdc++` | 15.2.0-r5 | GPL-3.0-or-later WITH GCC-exception-3.1 | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/gcc |
| `libunistring` | 1.4.2-r0 | GPL-2.0-or-later OR LGPL-3.0-or-later | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/libunistring |
| `mpdecimal` | 4.0.1-r0 | BSD-2-Clause | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/mpdecimal |
| `musl` | 1.2.6-r2 | MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/musl |
| `musl-utils` | 1.2.6-r2 | MIT AND BSD-2-Clause AND GPL-2.0-or-later | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/musl |
| `ncurses-terminfo-base` | 6.6_p20260516-r0 | X11 (MIT-like) | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/ncurses |
| `nghttp2-libs` | 1.70.0-r0 | MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/nghttp2 |
| `pcre2` | 10.49-r0 | BSD-3-Clause | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/pcre2 |
| `py3-pip` | 26.1.2-r0 | MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/py3-pip |
| `py3-pip-pyc` | 26.1.2-r0 | MIT | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/py3-pip |
| `pyc` | 3.14.8-r0 | PSF-2.0 | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/python3 |
| `python3` | 3.14.8-r0 | PSF-2.0 | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/python3 |
| `python3-pyc` | 3.14.8-r0 | PSF-2.0 | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/python3 |
| `python3-pycache-pyc0` | 3.14.8-r0 | PSF-2.0 | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/python3 |
| `readline` | 8.3.3-r1 | GPL-3.0-or-later | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/readline |
| `scanelf` | 1.3.9-r1 | GPL-2.0-only | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/pax-utils |
| `sqlite-libs` | 3.53.4-r0 | Blessing (Public Domain) | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/sqlite |
| `ssl_client` | 1.37.0-r31 | GPL-2.0-only | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/busybox |
| `xz-libs` | 5.8.4-r0 | GPL-2.0-or-later AND 0BSD AND Public-Domain AND LGPL-2.1-or-later | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/xz |
| `zlib` | 1.3.2-r0 | Zlib | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/zlib |
| `zstd-libs` | 1.5.7-r2 | BSD-3-Clause OR GPL-2.0-or-later | https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/zstd |

---

## 4. Python Runtime Packages (125 Distributions)

The Python 3.14 environment in the runner container contains Semgrep, Checkov, and their dependencies:

| Package | Version | License | Official Upstream / PyPI |
| :--- | :--- | :--- | :--- |
| `aiodns` | 3.6.1 | MIT | https://pypi.org/project/aiodns/ |
| `aiohappyeyeballs` | 2.7.1 | PSF-2.0 | https://pypi.org/project/aiohappyeyeballs/ |
| `aiohttp` | 3.14.5 | Custom / Multi | https://pypi.org/project/aiohttp/ |
| `aiomultiprocess` | 0.9.1 | MIT License | https://pypi.org/project/aiomultiprocess/ |
| `aiosignal` | 1.4.0 | Apache 2.0 | https://pypi.org/project/aiosignal/ |
| `annotated-types` | 0.8.0 | MIT License | https://pypi.org/project/annotated-types/ |
| `argcomplete` | 3.7.2 | Apache Software License | https://pypi.org/project/argcomplete/ |
| `asteval` | 1.0.6 | The MIT License | https://pypi.org/project/asteval/ |
| `attrs` | 26.1.0 | Custom / Multi | https://pypi.org/project/attrs/ |
| `bc-detect-secrets` | 1.5.50 | Apache License 2.0 | https://pypi.org/project/bc-detect-secrets/ |
| `bc-jsonpath-ng` | 1.6.1 | Apache License 2.0 | https://pypi.org/project/bc-jsonpath-ng/ |
| `bc-python-hcl2` | 0.4.3 | MIT | https://pypi.org/project/bc-python-hcl2/ |
| `beartype` | 0.23.1 | MIT License | https://pypi.org/project/beartype/ |
| `beautifulsoup4` | 4.15.0 | MIT License | https://pypi.org/project/beautifulsoup4/ |
| `boltons` | 21.0.0 | BSD | https://pypi.org/project/boltons/ |
| `boolean.py` | 5.0 | BSD-2-Clause | https://pypi.org/project/boolean.py/ |
| `boto3` | 1.35.49 | Apache License 2.0 | https://pypi.org/project/boto3/ |
| `botocore` | 1.35.99 | Apache License 2.0 | https://pypi.org/project/botocore/ |
| `bracex` | 3.1 | MIT License | https://pypi.org/project/bracex/ |
| `cached-property` | 2.0.1 | BSD | https://pypi.org/project/cached-property/ |
| `cachetools` | 5.5.2 | MIT | https://pypi.org/project/cachetools/ |
| `certifi` | 2026.7.22 | MPL-2.0 | https://pypi.org/project/certifi/ |
| `cffi` | 2.1.1 | Custom / Multi | https://pypi.org/project/cffi/ |
| `charset-normalizer` | 3.5.2 | MIT | https://pypi.org/project/charset-normalizer/ |
| `checkov` | 3.3.19 | Apache License 2.0 | https://pypi.org/project/checkov/ |
| `click` | 8.5.0 | Custom / Multi | https://pypi.org/project/click/ |
| `click-option-group` | 0.5.9 | BSD License | https://pypi.org/project/click-option-group/ |
| `cloudsplaining` | 0.7.0 | MIT License | https://pypi.org/project/cloudsplaining/ |
| `colorama` | 0.4.6 | BSD License | https://pypi.org/project/colorama/ |
| `ConfigArgParse` | 1.8.0 | MIT | https://pypi.org/project/ConfigArgParse/ |
| `contextlib2` | 21.6.0 | PSF License | https://pypi.org/project/contextlib2/ |
| `cyclonedx-python-lib` | 7.6.2 | Apache-2.0 | https://pypi.org/project/cyclonedx-python-lib/ |
| `decorator` | 5.3.1 | BSD-2-Clause | https://pypi.org/project/decorator/ |
| `defusedxml` | 0.7.1 | PSFL | https://pypi.org/project/defusedxml/ |
| `Deprecated` | 3.0.0 | Custom / Multi | https://pypi.org/project/Deprecated/ |
| `docker` | 7.2.0 | Apache Software License | https://pypi.org/project/docker/ |
| `dockerfile-parse` | 2.0.1 | BSD | https://pypi.org/project/dockerfile-parse/ |
| `dpath` | 2.1.3 | MIT | https://pypi.org/project/dpath/ |
| `ecdsa` | 0.19.2 | MIT | https://pypi.org/project/ecdsa/ |
| `exceptiongroup` | 1.2.2 | MIT License | https://pypi.org/project/exceptiongroup/ |
| `face` | 26.0.1 | Custom / Multi | https://pypi.org/project/face/ |
| `frozenlist` | 1.8.0 | Apache-2.0 | https://pypi.org/project/frozenlist/ |
| `gitdb` | 4.0.12 | BSD License | https://pypi.org/project/gitdb/ |
| `GitPython` | 3.2.1 | BSD-3-Clause | https://pypi.org/project/GitPython/ |
| `glom` | 22.1.0 | BSD | https://pypi.org/project/glom/ |
| `googleapis-common-protos` | 1.75.0 | Apache 2.0 | https://pypi.org/project/googleapis-common-protos/ |
| `idna` | 3.20 | Custom / Multi | https://pypi.org/project/idna/ |
| `importlib_metadata` | 7.1.0 | Apache Software License | https://pypi.org/project/importlib_metadata/ |
| `Jinja2` | 3.1.6 | BSD License | https://pypi.org/project/Jinja2/ |
| `jmespath` | 1.1.0 | MIT | https://pypi.org/project/jmespath/ |
| `jsonschema` | 4.26.0 | Custom / Multi | https://pypi.org/project/jsonschema/ |
| `jsonschema-specifications` | 2025.9.1 | Custom / Multi | https://pypi.org/project/jsonschema-specifications/ |
| `junit-xml` | 1.9 | MIT | https://pypi.org/project/junit-xml/ |
| `lark` | 1.3.1 | MIT | https://pypi.org/project/lark/ |
| `license-expression` | 30.4.4 | Apache-2.0 | https://pypi.org/project/license-expression/ |
| `Markdown` | 3.11.1 | Custom / Multi | https://pypi.org/project/Markdown/ |
| `markdown-it-py` | 4.2.0 | MIT License | https://pypi.org/project/markdown-it-py/ |
| `MarkupSafe` | 3.0.4 | Custom / Multi | https://pypi.org/project/MarkupSafe/ |
| `mdurl` | 0.1.2 | MIT License | https://pypi.org/project/mdurl/ |
| `multidict` | 7.1.0 | Custom / Multi | https://pypi.org/project/multidict/ |
| `networkx` | 2.6.3 | BSD License | https://pypi.org/project/networkx/ |
| `numpy` | 2.5.4 | Custom / Multi | https://pypi.org/project/numpy/ |
| `opentelemetry-api` | 1.25.0 | Apache-2.0 | https://pypi.org/project/opentelemetry-api/ |
| `opentelemetry-exporter-otlp-proto-common` | 1.25.0 | Apache-2.0 | https://pypi.org/project/opentelemetry-exporter-otlp-proto-common/ |
| `opentelemetry-exporter-otlp-proto-http` | 1.25.0 | Apache-2.0 | https://pypi.org/project/opentelemetry-exporter-otlp-proto-http/ |
| `opentelemetry-instrumentation` | 0.46b0 | Apache Software License | https://pypi.org/project/opentelemetry-instrumentation/ |
| `opentelemetry-instrumentation-requests` | 0.46b0 | Apache Software License | https://pypi.org/project/opentelemetry-instrumentation-requests/ |
| `opentelemetry-proto` | 1.25.0 | Apache-2.0 | https://pypi.org/project/opentelemetry-proto/ |
| `opentelemetry-sdk` | 1.25.0 | Apache-2.0 | https://pypi.org/project/opentelemetry-sdk/ |
| `opentelemetry-semantic-conventions` | 0.46b0 | Apache-2.0 | https://pypi.org/project/opentelemetry-semantic-conventions/ |
| `opentelemetry-util-http` | 0.46b0 | Apache Software License | https://pypi.org/project/opentelemetry-util-http/ |
| `orjson` | 3.13.0 | Apache Software License | https://pypi.org/project/orjson/ |
| `packageurl-python` | 0.13.4 | MIT | https://pypi.org/project/packageurl-python/ |
| `packaging` | 23.2 | Apache Software License | https://pypi.org/project/packaging/ |
| `peewee` | 3.19.0 | Custom / Multi | https://pypi.org/project/peewee/ |
| `pip` | 26.1.2 | Custom / Multi | https://pypi.org/project/pip/ |
| `platformdirs` | 4.13.3 | MIT License | https://pypi.org/project/platformdirs/ |
| `ply` | 3.11 | BSD | https://pypi.org/project/ply/ |
| `policy_sentry` | 0.13.2 | MIT License | https://pypi.org/project/policy_sentry/ |
| `prettytable` | 3.18.0 | Custom / Multi | https://pypi.org/project/prettytable/ |
| `propcache` | 0.5.4 | Apache-2.0 | https://pypi.org/project/propcache/ |
| `protobuf` | 4.25.9 | 3-Clause BSD License | https://pypi.org/project/protobuf/ |
| `py-serializable` | 1.1.2 | Apache-2.0 | https://pypi.org/project/py-serializable/ |
| `pycares` | 4.11.0 | MIT | https://pypi.org/project/pycares/ |
| `pycep-parser` | 0.5.1 | Apache-2.0 | https://pypi.org/project/pycep-parser/ |
| `pycparser` | 3.11 | Custom / Multi | https://pypi.org/project/pycparser/ |
| `pydantic` | 2.14.1 | Custom / Multi | https://pypi.org/project/pydantic/ |
| `pydantic_core` | 2.50.1 | Custom / Multi | https://pypi.org/project/pydantic_core/ |
| `Pygments` | 2.21.0 | Custom / Multi | https://pypi.org/project/Pygments/ |
| `pyparsing` | 3.3.3 | Custom / Multi | https://pypi.org/project/pyparsing/ |
| `python-dateutil` | 2.9.0.post0 | Dual License | https://pypi.org/project/python-dateutil/ |
| `PyYAML` | 6.0.3 | MIT | https://pypi.org/project/PyYAML/ |
| `rdflib` | 7.6.0 | BSD-3-Clause | https://pypi.org/project/rdflib/ |
| `referencing` | 0.37.0 | Custom / Multi | https://pypi.org/project/referencing/ |
| `regex` | 2026.9.29 | Custom / Multi | https://pypi.org/project/regex/ |
| `requests` | 2.34.2 | Apache-2.0 | https://pypi.org/project/requests/ |
| `rich` | 15.0.0 | MIT | https://pypi.org/project/rich/ |
| `rpds-py` | 2026.9.1 | Custom / Multi | https://pypi.org/project/rpds-py/ |
| `ruamel.yaml` | 0.17.40 | MIT license | https://pypi.org/project/ruamel.yaml/ |
| `rustworkx` | 0.18.1 | Custom / Multi | https://pypi.org/project/rustworkx/ |
| `s3transfer` | 0.10.4 | Apache License 2.0 | https://pypi.org/project/s3transfer/ |
| `schema` | 0.7.5 | MIT | https://pypi.org/project/schema/ |
| `semantic-version` | 2.10.0 | BSD | https://pypi.org/project/semantic-version/ |
| `semgrep` | 1.80.0 | GNU Lesser General Public License v2 (LGPLv2) | https://pypi.org/project/semgrep/ |
| `setuptools` | 71.1.0 | MIT License | https://pypi.org/project/setuptools/ |
| `six` | 1.17.0 | MIT | https://pypi.org/project/six/ |
| `smmap` | 5.0.3 | BSD-3-Clause | https://pypi.org/project/smmap/ |
| `sortedcontainers` | 2.4.0 | Apache 2.0 | https://pypi.org/project/sortedcontainers/ |
| `soupsieve` | 3.0.3 | MIT License | https://pypi.org/project/soupsieve/ |
| `spdx-tools` | 0.8.5 | Custom / Multi | https://pypi.org/project/spdx-tools/ |
| `tabulate` | 0.9.0 | MIT | https://pypi.org/project/tabulate/ |
| `termcolor` | 2.3.0 | MIT | https://pypi.org/project/termcolor/ |
| `tomli` | 2.0.2 | MIT License | https://pypi.org/project/tomli/ |
| `tqdm` | 4.70.1 | MPL-2.0 AND MIT | https://pypi.org/project/tqdm/ |
| `typing-inspection` | 0.4.4 | Custom / Multi | https://pypi.org/project/typing-inspection/ |
| `typing_extensions` | 4.16.0 | Custom / Multi | https://pypi.org/project/typing_extensions/ |
| `unidiff` | 1.0.1 | MIT | https://pypi.org/project/unidiff/ |
| `uritools` | 6.1.3 | Custom / Multi | https://pypi.org/project/uritools/ |
| `urllib3` | 2.8.0 | Custom / Multi | https://pypi.org/project/urllib3/ |
| `wcmatch` | 8.5.2 | MIT License | https://pypi.org/project/wcmatch/ |
| `wcwidth` | 0.9.2 | MIT License | https://pypi.org/project/wcwidth/ |
| `wrapt` | 1.17.3 | BSD | https://pypi.org/project/wrapt/ |
| `xmltodict` | 1.0.4 | Custom / Multi | https://pypi.org/project/xmltodict/ |
| `yarl` | 1.25.1 | Apache-2.0 | https://pypi.org/project/yarl/ |
| `zipp` | 4.1.1 | Custom / Multi | https://pypi.org/project/zipp/ |

---

## 5. Copyleft Source Code Offer and Component Replacement Instructions

Certain components included in the runner image are licensed under the GNU General Public License (GPL)
or GNU Lesser General Public License (LGPL), including `semgrep` (LGPL-2.1), `busybox` (GPL-2.0),
`git` (GPL-2.0), `apk-tools` (GPL-2.0), and system utilities.

### 5.1 Obtaining Corresponding Source Code
The complete machine-readable corresponding source code for these components may be obtained:
1. **Directly from official upstream source repositories for the installed versions:**
   - **BusyBox 1.37.0:** https://busybox.net/downloads/busybox-1.37.0.tar.bz2
   - **Git 2.54.0:** https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.54.0.tar.xz
   - **apk-tools 3.0.8:** https://gitlab.alpinelinux.org/alpine/apk-tools/-/tree/v3.0.8
   - **Semgrep CE 1.80.0:** https://github.com/semgrep/semgrep/archive/refs/tags/v1.80.0.tar.gz
   - **Alpine 3.24 Package Source Trees (aports):** https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable
2. **Written Offer:**
   Upon written request to `contact@aadsec.xyz`, AADSec will provide a machine-readable copy of the
   corresponding source code for any GPL/LGPL binary distributed with this version, on physical media or via download, for up to three years from distribution.

### 5.2 Replacing or Relinking LGPL / GPL Components in the Runner
In accordance with LGPL-2.1 (Section 6) and GPL-2.0 (Section 2):
- Any user may modify or replace these components within the container image.
- Because `aadsec-runner` interacts with `semgrep`, `git`, and system utilities strictly via process invocation (`exec.CommandContext`), any component binary can be substituted without relinking the Go host binary:
  ```bash
  # Mount a replacement binary into the container at runtime:
  docker run -v /path/to/my-semgrep:/usr/local/bin/semgrep ghcr.io/aadieng100/aadsec-runner:0.1.0
  ```

---

## 6. Trivy Vulnerability Database Data Sources and Terms of Use

The runner image embeds a local cache of the Trivy vulnerability database (`ghcr.io/aquasecurity/trivy-db:2`).
The database aggregates public security advisories under their respective terms:

| Data Source | Primary URL | Terms of Use / License |
| :--- | :--- | :--- |
| **NVD (NIST)** | https://nvd.nist.gov/ | U.S. Government work, Public Domain / CC0 (https://nvd.nist.gov/general/terms-of-use) |
| **GitHub Advisory Database** | https://github.com/github/advisory-database | Creative Commons Attribution 4.0 International (CC-BY-4.0) |
| **Alpine Linux SecDB** | https://secdb.alpinelinux.org/ | Alpine Linux open-source data terms |
| **Red Hat Security Data** | https://access.redhat.com/security/data | Red Hat Security Data terms |
| **Debian Security Tracker** | https://security-tracker.debian.org/ | Debian Free Software Guidelines (DFSG) compliant |
| **Ubuntu CVE Tracker** | https://ubuntu.com/security/cve | Canonical Ltd. terms |

---

## 7. Full Texts of Software Licenses

### Apache License, Version 2.0 (Apache-2.0)
```text
Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS
```

### The MIT License (MIT)
```text
MIT License

Copyright (c) 2025 TAHRI Ahmed R.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### BSD 2-Clause License (BSD-2-Clause)
```text
Copyright (c) 2006-2022 by the respective authors (see AUTHORS file).
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

### BSD 3-Clause License (BSD-3-Clause)
```text
Copyright (c) Donald Stufft and individual contributors.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice,
       this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

### ISC License (ISC)
```text
Copyright (C) 2012 by Saúl Ibarra Corretgé

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

### Python Software Foundation License Version 2 (PSF-2.0)
```text
PYTHON SOFTWARE FOUNDATION LICENSE VERSION 2
--------------------------------------------

1. This LICENSE AGREEMENT is between the Python Software Foundation ("PSF"), and
the Individual or Organization ("Licensee") accessing and otherwise using this
software ("Python") in source or binary form and its associated documentation.

2. Subject to the terms and conditions of this License Agreement, PSF hereby
grants Licensee a nonexclusive, royalty-free, world-wide license to reproduce,
analyze, test, perform and/or display publicly, prepare derivative works, distribute,
and otherwise use Python alone or in any derivative version, provided, however, that
PSF's License Agreement and PSF's notice of copyright are retained in Python alone
or in any derivative version prepared by Licensee.

3. In the event Licensee prepares a derivative work that is based on or incorporates
Python or any part thereof, and wants to make the derivative work available to
others as provided herein, then Licensee hereby agrees to include in any such work
a brief summary of the changes made to Python.

4. PSF is making Python available to Licensee on an "AS IS" basis. PSF MAKES NO
REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED. BY WAY OF EXAMPLE, BUT NOT
LIMITATION, PSF MAKES NO AND DISCLAIMS ANY REPRESENTATION OR WARRANTY OF
MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT THE USE OF PYTHON
WILL NOT INFRINGE ANY THIRD PARTY RIGHTS.
```

### Mozilla Public License Version 2.0 (MPL-2.0)
```text
Mozilla Public License Version 2.0
==================================

1. Definitions
--------------

1.1. "Contributor"
    means each individual or legal entity that creates, contributes to
    the creation of, or owns Covered Software.

1.2. "Contributor Version"
    means the combination of the Contributions of others (if any) used
    by a Contributor and that particular Contributor's Contribution.

1.3. "Contribution"
    means Covered Software of a particular Contributor.

1.4. "Covered Software"
    means Source Code Form to which the initial Contributor has attached
    the notice in Exhibit A, the Executable Form of such Source Code
    Form, and Modifications of such Source Code Form, in each case
    including portions thereof.

1.5. "Incompatible With Secondary Licenses"
    means

    (a) that the initial Contributor has attached the notice described
        in Exhibit B to the Covered Software; or

    (b) that the Covered Software was made available under the terms of
        version 1.1 or earlier of the License, but not also under the
        terms of a Secondary License.

1.6. "Executable Form"
    means any form of the work other than Source Code Form.

1.7. "Larger Work"
    means a work that combines Covered Software with other material, in 
    a separate file or files, that is not Covered Software.

1.8. "License"
    means this document.

1.9. "Licensable"
    means having the right to grant, to the maximum extent possible,
    whether at the time of the initial grant or subsequently, any and
    all of the rights conveyed by this License.

1.10. "Modifications"
    means any of the following:

    (a) any file in Source Code Form that results from an addition to,
        deletion from, or modification of the contents of Covered
        Software; or

    (b) any new file in Source Code Form that contains any Covered
        Software.

1.11. "Patent Claims" of a Contributor
    means any patent claim(s), including without limitation, method,
    process, and apparatus claims, in any patent Licensable by such
    Contributor that would be infringed, but for the grant of the
    License, by the making, using, selling, offering for sale, having
    made, import, or transfer of either its Contributions or its
    Contributor Version.

1.12. "Secondary License"
    means either the GNU General Public License, Version 2.0, the GNU
    Lesser General Public License, Version 2.1, the GNU Affero General
    Public License, Version 3.0, or any later versions of those
    licenses.

1.13. "Source Code Form"
    means the form of the work preferred for making modifications.

1.14. "You" (or "Your")
    means an individual or a legal entity exercising rights under this
    License. For legal entities, "You" includes any entity that
    controls, is controlled by, or is under common control with You. For
    purposes of this definition, "control" means (a) the power, direct
    or indirect, to cause the direction or management of such entity,
    whether by contract or otherwise, or (b) ownership of more than
    fifty percent (50%) of the outstanding shares or beneficial
    ownership of such entity.

2. License Grants and Conditions
--------------------------------

2.1. Grants

Each Contributor hereby grants You a world-wide, royalty-free,
non-exclusive license:

(a) under intellectual property rights (other than patent or trademark)
    Licensable by such Contributor to use, reproduce, make available,
    modify, display, perform, distribute, and otherwise exploit its
    Contributions, either on an unmodified basis, with Modifications, or
    as part of a Larger Work; and

(b) under Patent Claims of such Contributor to make, use, sell, offer
    for sale, have made, import, and otherwise transfer either its
    Contributions or its Contributor Version.

2.2. Effective Date

The licenses granted in Section 2.1 with respect to any Contribution
become effective for each Contribution on the date the Contributor first
distributes such Contribution.

2.3. Limitations on Grant Scope

The licenses granted in this Section 2 are the only rights granted under
this License. No additional rights or licenses will be implied from the
distribution or licensing of Covered Software under this License.
Notwithstanding Section 2.1(b) above, no patent license is granted by a
Contributor:

(a) for any code that a Contributor has removed from Covered Software;
    or

(b) for infringements caused by: (i) Your and any other third party's
    modifications of Covered Software, or (ii) the combination of its
    Contributions with other software (except as part of its Contributor
    Version); or

(c) under Patent Claims infringed by Covered Software in the absence of
    its Contributions.

This License does not grant any rights in the trademarks, service marks,
or logos of any Contributor (except as may be necessary to comply with
the notice requirements in Section 3.4).

2.4. Subsequent Licenses

No Contributor makes additional grants as a result of Your choice to
distribute the Covered Software under a subsequent version of this
License (see Section 10.2) or under the terms of a Secondary License (if
permitted under the terms of Section 3.3).

2.5. Representation

Each Contributor represents that the Contributor believes its
Contributions are its original creation(s) or it has sufficient rights
to grant the rights to its Contributions conveyed by this License.

2.6. Fair Use

This License is not intended to limit any rights You have under
applicable copyright doctrines of fair use, fair dealing, or other
equivalents.

2.7. Conditions

Sections 3.1, 3.2, 3.3, and 3.4 are conditions of the licenses granted
in Section 2.1.

3. Responsibilities
-------------------

3.1. Distribution of Source Form

All distribution of Covered Software in Source Code Form, including any
Modifications that You create or to which You contribute, must be under
the terms of this License. You must inform recipients that the Source
Code Form of the Covered Software is governed by the terms of this
License, and how they can obtain a copy of this License. You may not
attempt to alter or restrict the recipients' rights in the Source Code
Form.

3.2. Distribution of Executable Form

If You distribute Covered Software in Executable Form then:

(a) such Covered Software must also be made available in Source Code
    Form, as described in Section 3.1, and You must inform recipients of
    the Executable Form how they can obtain a copy of such Source Code
    Form by reasonable means in a timely manner, at a charge no more
    than the cost of distribution to the recipient; and

(b) You may distribute such Executable Form under the terms of this
    License, or sublicense it under different terms, provided that the
    license for the Executable Form does not attempt to limit or alter
    the recipients' rights in the Source Code Form under this License.

3.3. Distribution of a Larger Work

You may create and distribute a Larger Work under terms of Your choice,
provided that You also comply with the requirements of this License for
the Covered Software. If the Larger Work is a combination of Covered
Software with a work governed by one or more Secondary Licenses, and the
Covered Software is not Incompatible With Secondary Licenses, this
License permits You to additionally distribute such Covered Software
under the terms of such Secondary License(s), so that the recipient of
the Larger Work may, at their option, further distribute the Covered
Software under the terms of either this License or such Secondary
License(s).

3.4. Notices

You may not remove or alter the substance of any license notices
(including copyright notices, patent notices, disclaimers of warranty,
or limitations of liability) contained within the Source Code Form of
the Covered Software, except that You may alter any license notices to
the extent required to remedy known factual inaccuracies.

3.5. Application of Additional Terms

You may choose to offer, and to charge a fee for, warranty, support,
indemnity or liability obligations to one or more recipients of Covered
Software. However, You may do so only on Your own behalf, and not on
behalf of any Contributor. You must make it absolutely clear that any
such warranty, support, indemnity, or liability obligation is offered by
You alone, and You hereby agree to indemnify every Contributor for any
liability incurred by such Contributor as a result of warranty, support,
indemnity or liability terms You offer. You may include additional
disclaimers of warranty and limitations of liability specific to any
jurisdiction.

4. Inability to Comply Due to Statute or Regulation
---------------------------------------------------

If it is impossible for You to comply with any of the terms of this
License with respect to some or all of the Covered Software due to
statute, judicial order, or regulation then You must: (a) comply with
the terms of this License to the maximum extent possible; and (b)
describe the limitations and the code they affect. Such description must
be placed in a text file included with all distributions of the Covered
Software under this License. Except to the extent prohibited by statute
or regulation, such description must be sufficiently detailed for a
recipient of ordinary skill to be able to understand it.

5. Termination
--------------

5.1. The rights granted under this License will terminate automatically
if You fail to comply with any of its terms. However, if You become
compliant, then the rights granted under this License from a particular
Contributor are reinstated (a) provisionally, unless and until such
Contributor explicitly and finally terminates Your grants, and (b) on an
ongoing basis, if such Contributor fails to notify You of the
non-compliance by some reasonable means prior to 60 days after You have
come back into compliance. Moreover, Your grants from a particular
Contributor are reinstated on an ongoing basis if such Contributor
notifies You of the non-compliance by some reasonable means, this is the
first time You have received notice of non-compliance with this License
from such Contributor, and You become compliant prior to 30 days after
Your receipt of the notice.

5.2. If You initiate litigation against any entity by asserting a patent
infringement claim (excluding declaratory judgment actions,
counter-claims, and cross-claims) alleging that a Contributor Version
directly or indirectly infringes any patent, then the rights granted to
You by any and all Contributors for the Covered Software under Section
2.1 of this License shall terminate.

5.3. In the event of termination under Sections 5.1 or 5.2 above, all
end user license agreements (excluding distributors and resellers) which
have been validly granted by You or Your distributors under this License
prior to termination shall survive termination.

************************************************************************
*                                                                      *
*  6. Disclaimer of Warranty                                           *
*  -------------------------                                           *
*                                                                      *
*  Covered Software is provided under this License on an "as is"       *
*  basis, without warranty of any kind, either expressed, implied, or  *
*  statutory, including, without limitation, warranties that the       *
*  Covered Software is free of defects, merchantable, fit for a        *
*  particular purpose or non-infringing. The entire risk as to the     *
*  quality and performance of the Covered Software is with You.        *
*  Should any Covered Software prove defective in any respect, You     *
*  (not any Contributor) assume the cost of any necessary servicing,   *
*  repair, or correction. This disclaimer of warranty constitutes an   *
*  essential part of this License. No use of any Covered Software is   *
*  authorized under this License except under this disclaimer.         *
*                                                                      *
************************************************************************

************************************************************************
*                                                                      *
*  7. Limitation of Liability                                          *
*  --------------------------                                          *
*                                                                      *
*  Under no circumstances and under no legal theory, whether tort      *
*  (including negligence), contract, or otherwise, shall any           *
*  Contributor, or anyone who distributes Covered Software as          *
*  permitted above, be liable to You for any direct, indirect,         *
*  special, incidental, or consequential damages of any character      *
*  including, without limitation, damages for lost profits, loss of    *
*  goodwill, work stoppage, computer failure or malfunction, or any    *
*  and all other commercial damages or losses, even if such party      *
*  shall have been informed of the possibility of such damages. This   *
*  limitation of liability shall not apply to liability for death or   *
*  personal injury resulting from such party's negligence to the       *
*  extent applicable law prohibits such limitation. Some               *
*  jurisdictions do not allow the exclusion or limitation of           *
*  incidental or consequential damages, so this exclusion and          *
*  limitation may not apply to You.                                    *
*                                                                      *
************************************************************************

8. Litigation
-------------

Any litigation relating to this License may be brought only in the
courts of a jurisdiction where the defendant maintains its principal
place of business and such litigation shall be governed by laws of that
jurisdiction, without reference to its conflict-of-law provisions.
Nothing in this Section shall prevent a party's ability to bring
cross-claims or counter-claims.

9. Miscellaneous
----------------

This License represents the complete agreement concerning the subject
matter hereof. If any provision of this License is held to be
unenforceable, such provision shall be reformed only to the extent
necessary to make it enforceable. Any law or regulation which provides
that the language of a contract shall be construed against the drafter
shall not be used to construe this License against a Contributor.

10. Versions of the License
---------------------------

10.1. New Versions

Mozilla Foundation is the license steward. Except as provided in Section
10.3, no one other than the license steward has the right to modify or
publish new versions of this License. Each version will be given a
distinguishing version number.

10.2. Effect of New Versions

You may distribute the Covered Software under the terms of the version
of the License under which You originally received the Covered Software,
or under the terms of any subsequent version published by the license
steward.

10.3. Modified Versions

If you create software not governed by this License, and you want to
create a new license for such software, you may create and use a
modified version of this License if you rename the license and remove
any references to the name of the license steward (except to note that
such modified license differs from this License).

10.4. Distributing Source Code Form that is Incompatible With Secondary
Licenses

If You choose to distribute Source Code Form that is Incompatible With
Secondary Licenses under the terms of this version of the License, the
notice described in Exhibit B of this License must be attached.

Exhibit A - Source Code Form License Notice
-------------------------------------------

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

If it is not possible or desirable to put the notice in a particular
file, then You may include the notice in a location (such as a LICENSE
file in a relevant directory) where a recipient would be likely to look
for such a notice.

You may add additional accurate notices of copyright ownership.

Exhibit B - "Incompatible With Secondary Licenses" Notice
---------------------------------------------------------

  This Source Code Form is "Incompatible With Secondary Licenses", as
  defined by the Mozilla Public License, v. 2.0.
```

### GNU Lesser General Public License, Version 2.1 (LGPL-2.1)
```text
GNU LESSER GENERAL PUBLIC LICENSE
                       Version 2.1, February 1999

 Copyright (C) 1991, 1999 Free Software Foundation, Inc.
 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

[This is the first released version of the Lesser GPL.  It also counts
 as the successor of the GNU Library Public License, version 2, hence
 the version number 2.1.]

                            Preamble

  The licenses for most software are designed to take away your
freedom to share and change it.  By contrast, the GNU General Public
Licenses are intended to guarantee your freedom to share and change
free software--to make sure the software is free for all its users.

  This license, the Lesser General Public License, applies to some
specially designated software packages--typically libraries--of the
Free Software Foundation and other authors who decide to use it.  You
can use it too, but we suggest you first think carefully about whether
this license or the ordinary General Public License is the better
strategy to use in any particular case, based on the explanations below.

  When we speak of free software, we are referring to freedom of use,
not price.  Our General Public Licenses are designed to make sure that
you have the freedom to distribute copies of free software (and charge
for this service if you wish); that you receive source code or can get
it if you want it; that you can change the software and use pieces of
it in new free programs; and that you are informed that you can do
these things.

  To protect your rights, we need to make restrictions that forbid
distributors to deny you these rights or to ask you to surrender these
rights.  These restrictions translate to certain responsibilities for
you if you distribute copies of the library or if you modify it.

  For example, if you distribute copies of the library, whether gratis
or for a fee, you must give the recipients all the rights that we gave
you.  You must make sure that they, too, receive or can get the source
code.  If you link other code with the library, you must provide
complete object files to the recipients, so that they can relink them
with the library after making changes to the library and recompiling
it.  And you must show them these terms so they know their rights.

  We protect your rights with a two-step method: (1) we copyright the
library, and (2) we offer you this license, which gives you legal
permission to copy, distribute and/or modify the library.

  To protect each distributor, we want to make it very clear that
there is no warranty for the free library.  Also, if the library is
modified by someone else and passed on, the recipients should know
that what they have is not the original version, so that the original
author's reputation will not be affected by problems that might be
introduced by others.

  Finally, software patents pose a constant threat to the existence of
any free program.  We wish to make sure that a company cannot
effectively restrict the users of a free program by obtaining a
restrictive license from a patent holder.  Therefore, we insist that
any patent license obtained for a version of the library must be
consistent with the full freedom of use specified in this license.

  Most GNU software, including some libraries, is covered by the
ordinary GNU General Public License.  This license, the GNU Lesser
General Public License, applies to certain designated libraries, and
is quite different from the ordinary General Public License.  We use
this license for certain libraries in order to permit linking those
libraries into non-free programs.

  When a program is linked with a library, whether statically or using
a shared library, the combination of the two is legally speaking a
combined work, a derivative of the original library.  The ordinary
General Public License therefore permits such linking only if the
entire combination fits its criteria of freedom.  The Lesser General
Public License permits more lax criteria for linking other code with
the library.

  We call this license the "Lesser" General Public License because it
does Less to protect the user's freedom than the ordinary General
Public License.  It also provides other free software developers Less
of an advantage over competing non-free programs.  These disadvantages
are the reason we use the ordinary General Public License for many
libraries.  However, the Lesser license provides advantages in certain
special circumstances.

  For example, on rare occasions, there may be a special need to
encourage the widest possible use of a certain library, so that it becomes
a de-facto standard.  To achieve this, non-free programs must be
allowed to use the library.  A more frequent case is that a free
library does the same job as widely used non-free libraries.  In this
case, there is little to gain by limiting the free library to free
software only, so we use the Lesser General Public License.

  In other cases, permission to use a particular library in non-free
programs enables a greater number of people to use a large body of
free software.  For example, permission to use the GNU C Library in
non-free programs enables many more people to use the whole GNU
operating system, as well as its variant, the GNU/Linux operating
system.

  Although the Lesser General Public License is Less protective of the
users' freedom, it does ensure that the user of a program that is
linked with the Library has the freedom and the wherewithal to run
that program using a modified version of the Library.

  The precise terms and conditions for copying, distribution and
modification follow.  Pay close attention to the difference between a
"work based on the library" and a "work that uses the library".  The
former contains code derived from the library, whereas the latter must
be combined with the library in order to run.

                  GNU LESSER GENERAL PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. This License Agreement applies to any software library or other
program which contains a notice placed by the copyright holder or
other authorized party saying it may be distributed under the terms of
this Lesser General Public License (also called "this License").
Each licensee is addressed as "you".

  A "library" means a collection of software functions and/or data
prepared so as to be conveniently linked with application programs
(which use some of those functions and data) to form executables.

  The "Library", below, refers to any such software library or work
which has been distributed under these terms.  A "work based on the
Library" means either the Library or any derivative work under
copyright law: that is to say, a work containing the Library or a
portion of it, either verbatim or with modifications and/or translated
straightforwardly into another language.  (Hereinafter, translation is
included without limitation in the term "modification".)

  "Source code" for a work means the preferred form of the work for
making modifications to it.  For a library, complete source code means
all the source code for all modules it contains, plus any associated
interface definition files, plus the scripts used to control compilation
and installation of the library.

  Activities other than copying, distribution and modification are not
covered by this License; they are outside its scope.  The act of
running a program using the Library is not restricted, and output from
such a program is covered only if its contents constitute a work based
on the Library (independent of the use of the Library in a tool for
writing it).  Whether that is true depends on what the Library does
and what the program that uses the Library does.

  1. You may copy and distribute verbatim copies of the Library's
complete source code as you receive it, in any medium, provided that
you conspicuously and appropriately publish on each copy an
appropriate copyright notice and disclaimer of warranty; keep intact
all the notices that refer to this License and to the absence of any
warranty; and distribute a copy of this License along with the
Library.

  You may charge a fee for the physical act of transferring a copy,
and you may at your option offer warranty protection in exchange for a
fee.

  2. You may modify your copy or copies of the Library or any portion
of it, thus forming a work based on the Library, and copy and
distribute such modifications or work under the terms of Section 1
above, provided that you also meet all of these conditions:

    a) The modified work must itself be a software library.

    b) You must cause the files modified to carry prominent notices
    stating that you changed the files and the date of any change.

    c) You must cause the whole of the work to be licensed at no
    charge to all third parties under the terms of this License.

    d) If a facility in the modified Library refers to a function or a
    table of data to be supplied by an application program that uses
    the facility, other than as an argument passed when the facility
    is invoked, then you must make a good faith effort to ensure that,
    in the event an application does not supply such function or
    table, the facility still operates, and performs whatever part of
    its purpose remains meaningful.

    (For example, a function in a library to compute square roots has
    a purpose that is entirely well-defined independent of the
    application.  Therefore, Subsection 2d requires that any
    application-supplied function or table used by this function must
    be optional: if the application does not supply it, the square
    root function must still compute square roots.)

These requirements apply to the modified work as a whole.  If
identifiable sections of that work are not derived from the Library,
and can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to those
sections when you distribute them as separate works.  But when you
distribute the same sections as part of a whole which is a work based
on the Library, the distribution of the whole must be on the terms of
this License, whose permissions for other licensees extend to the
entire whole, and thus to each and every part regardless of who wrote
it.

Thus, it is not the intent of this section to claim rights or contest
your rights to work written entirely by you; rather, the intent is to
exercise the right to control the distribution of derivative or
collective works based on the Library.

In addition, mere aggregation of another work not based on the Library
with the Library (or with a work based on the Library) on a volume of
a storage or distribution medium does not bring the other work under
the scope of this License.

  3. You may opt to apply the terms of the ordinary GNU General Public
License instead of this License to a given copy of the Library.  To do
this, you must alter all the notices that refer to this License, so
that they refer to the ordinary GNU General Public License, version 2,
instead of to this License.  (If a newer version than version 2 of the
ordinary GNU General Public License has appeared, then you can specify
that version instead if you wish.)  Do not make any other change in
these notices.

  Once this change is made in a given copy, it is irreversible for
that copy, so the ordinary GNU General Public License applies to all
subsequent copies and derivative works made from that copy.

  This option is useful when you wish to copy part of the code of
the Library into a program that is not a library.

  4. You may copy and distribute the Library (or a portion or
derivative of it, under Section 2) in object code or executable form
under the terms of Sections 1 and 2 above provided that you accompany
it with the complete corresponding machine-readable source code, which
must be distributed under the terms of Sections 1 and 2 above on a
medium customarily used for software interchange.

  If distribution of object code is made by offering access to copy
from a designated place, then offering equivalent access to copy the
source code from the same place satisfies the requirement to
distribute the source code, even though third parties are not
compelled to copy the source along with the object code.

  5. A program that contains no derivative of any portion of the
Library, but is designed to work with the Library by being compiled or
linked with it, is called a "work that uses the Library".  Such a
work, in isolation, is not a derivative work of the Library, and
therefore falls outside the scope of this License.

  However, linking a "work that uses the Library" with the Library
creates an executable that is a derivative of the Library (because it
contains portions of the Library), rather than a "work that uses the
library".  The executable is therefore covered by this License.
Section 6 states terms for distribution of such executables.

  When a "work that uses the Library" uses material from a header file
that is part of the Library, the object code for the work may be a
derivative work of the Library even though the source code is not.
Whether this is true is especially significant if the work can be
linked without the Library, or if the work is itself a library.  The
threshold for this to be true is not precisely defined by law.

  If such an object file uses only numerical parameters, data
structure layouts and accessors, and small macros and small inline
functions (ten lines or less in length), then the use of the object
file is unrestricted, regardless of whether it is legally a derivative
work.  (Executables containing this object code plus portions of the
Library will still fall under Section 6.)

  Otherwise, if the work is a derivative of the Library, you may
distribute the object code for the work under the terms of Section 6.
Any executables containing that work also fall under Section 6,
whether or not they are linked directly with the Library itself.

  6. As an exception to the Sections above, you may also combine or
link a "work that uses the Library" with the Library to produce a
work containing portions of the Library, and distribute that work
under terms of your choice, provided that the terms permit
modification of the work for the customer's own use and reverse
engineering for debugging such modifications.

  You must give prominent notice with each copy of the work that the
Library is used in it and that the Library and its use are covered by
this License.  You must supply a copy of this License.  If the work
during execution displays copyright notices, you must include the
copyright notice for the Library among them, as well as a reference
directing the user to the copy of this License.  Also, you must do one
of these things:

    a) Accompany the work with the complete corresponding
    machine-readable source code for the Library including whatever
    changes were used in the work (which must be distributed under
    Sections 1 and 2 above); and, if the work is an executable linked
    with the Library, with the complete machine-readable "work that
    uses the Library", as object code and/or source code, so that the
    user can modify the Library and then relink to produce a modified
    executable containing the modified Library.  (It is understood
    that the user who changes the contents of definitions files in the
    Library will not necessarily be able to recompile the application
    to use the modified definitions.)

    b) Use a suitable shared library mechanism for linking with the
    Library.  A suitable mechanism is one that (1) uses at run time a
    copy of the library already present on the user's computer system,
    rather than copying library functions into the executable, and (2)
    will operate properly with a modified version of the library, if
    the user installs one, as long as the modified version is
    interface-compatible with the version that the work was made with.

    c) Accompany the work with a written offer, valid for at
    least three years, to give the same user the materials
    specified in Subsection 6a, above, for a charge no more
    than the cost of performing this distribution.

    d) If distribution of the work is made by offering access to copy
    from a designated place, offer equivalent access to copy the above
    specified materials from the same place.

    e) Verify that the user has already received a copy of these
    materials or that you have already sent this user a copy.

  For an executable, the required form of the "work that uses the
Library" must include any data and utility programs needed for
reproducing the executable from it.  However, as a special exception,
the materials to be distributed need not include anything that is
normally distributed (in either source or binary form) with the major
components (compiler, kernel, and so on) of the operating system on
which the executable runs, unless that component itself accompanies
the executable.

  It may happen that this requirement contradicts the license
restrictions of other proprietary libraries that do not normally
accompany the operating system.  Such a contradiction means you cannot
use both them and the Library together in an executable that you
distribute.

  7. You may place library facilities that are a work based on the
Library side-by-side in a single library together with other library
facilities not covered by this License, and distribute such a combined
library, provided that the separate distribution of the work based on
the Library and of the other library facilities is otherwise
permitted, and provided that you do these two things:

    a) Accompany the combined library with a copy of the same work
    based on the Library, uncombined with any other library
    facilities.  This must be distributed under the terms of the
    Sections above.

    b) Give prominent notice with the combined library of the fact
    that part of it is a work based on the Library, and explaining
    where to find the accompanying uncombined form of the same work.

  8. You may not copy, modify, sublicense, link with, or distribute
the Library except as expressly provided under this License.  Any
attempt otherwise to copy, modify, sublicense, link with, or
distribute the Library is void, and will automatically terminate your
rights under this License.  However, parties who have received copies,
or rights, from you under this License will not have their licenses
terminated so long as such parties remain in full compliance.

  9. You are not required to accept this License, since you have not
signed it.  However, nothing else grants you permission to modify or
distribute the Library or its derivative works.  These actions are
prohibited by law if you do not accept this License.  Therefore, by
modifying or distributing the Library (or any work based on the
Library), you indicate your acceptance of this License to do so, and
all its terms and conditions for copying, distributing or modifying
the Library or works based on it.

  10. Each time you redistribute the Library (or any work based on the
Library), the recipient automatically receives a license from the
original licensor to copy, distribute, link with or modify the Library
subject to these terms and conditions.  You may not impose any further
restrictions on the recipients' exercise of the rights granted herein.
You are not responsible for enforcing compliance by third parties with
this License.

  11. If, as a consequence of a court judgment or allegation of patent
infringement or for any other reason (not limited to patent issues),
conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot
distribute so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you
may not distribute the Library at all.  For example, if a patent
license would not permit royalty-free redistribution of the Library by
all those who receive copies directly or indirectly through you, then
the only way you could satisfy both it and this License would be to
refrain entirely from distribution of the Library.

If any portion of this section is held invalid or unenforceable under any
particular circumstance, the balance of the section is intended to apply,
and the section as a whole is intended to apply in other circumstances.

It is not the purpose of this section to induce you to infringe any
patents or other property right claims or to contest validity of any
such claims; this section has the sole purpose of protecting the
integrity of the free software distribution system which is
implemented by public license practices.  Many people have made
generous contributions to the wide range of software distributed
through that system in reliance on consistent application of that
system; it is up to the author/donor to decide if he or she is willing
to distribute software through any other system and a licensee cannot
impose that choice.

This section is intended to make thoroughly clear what is believed to
be a consequence of the rest of this License.

  12. If the distribution and/or use of the Library is restricted in
certain countries either by patents or by copyrighted interfaces, the
original copyright holder who places the Library under this License may add
an explicit geographical distribution limitation excluding those countries,
so that distribution is permitted only in or among countries not thus
excluded.  In such case, this License incorporates the limitation as if
written in the body of this License.

  13. The Free Software Foundation may publish revised and/or new
versions of the Lesser General Public License from time to time.
Such new versions will be similar in spirit to the present version,
but may differ in detail to address new problems or concerns.

Each version is given a distinguishing version number.  If the Library
specifies a version number of this License which applies to it and
"any later version", you have the option of following the terms and
conditions either of that version or of any later version published by
the Free Software Foundation.  If the Library does not specify a
license version number, you may choose any version ever published by
the Free Software Foundation.

  14. If you wish to incorporate parts of the Library into other free
programs whose distribution conditions are incompatible with these,
write to the author to ask for permission.  For software which is
copyrighted by the Free Software Foundation, write to the Free
Software Foundation; we sometimes make exceptions for this.  Our
decision will be guided by the two goals of preserving the free status
of all derivatives of our free software and of promoting the sharing
and reuse of software generally.

                            NO WARRANTY

  15. BECAUSE THE LIBRARY IS LICENSED FREE OF CHARGE, THERE IS NO
WARRANTY FOR THE LIBRARY, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR
OTHER PARTIES PROVIDE THE LIBRARY "AS IS" WITHOUT WARRANTY OF ANY
KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE
LIBRARY IS WITH YOU.  SHOULD THE LIBRARY PROVE DEFECTIVE, YOU ASSUME
THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

  16. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN
WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY
AND/OR REDISTRIBUTE THE LIBRARY AS PERMITTED ABOVE, BE LIABLE TO YOU
FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR
CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE
LIBRARY (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE LIBRARY TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
DAMAGES.

                     END OF TERMS AND CONDITIONS
```

### GNU General Public License, Version 2.0 (GPL-2.0)
```text
GNU GENERAL PUBLIC LICENSE
		       Version 2, June 1991

 Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

			    Preamble

  The licenses for most software are designed to take away your
freedom to share and change it.  By contrast, the GNU General Public
License is intended to guarantee your freedom to share and change free
software--to make sure the software is free for all its users.  This
General Public License applies to most of the Free Software
Foundation's software and to any other program whose authors commit to
using it.  (Some other Free Software Foundation software is covered by
the GNU Lesser General Public License instead.)  You can apply it to
your programs, too.

  When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
this service if you wish), that you receive source code or can get it
if you want it, that you can change the software or use pieces of it
in new free programs; and that you know you can do these things.

  To protect your rights, we need to make restrictions that forbid
anyone to deny you these rights or to ask you to surrender the rights.
These restrictions translate to certain responsibilities for you if you
distribute copies of the software, or if you modify it.

  For example, if you distribute copies of such a program, whether
gratis or for a fee, you must give the recipients all the rights that
you have.  You must make sure that they, too, receive or can get the
source code.  And you must show them these terms so they know their
rights.

  We protect your rights with two steps: (1) copyright the software, and
(2) offer you this license which gives you legal permission to copy,
distribute and/or modify the software.

  Also, for each author's protection and ours, we want to make certain
that everyone understands that there is no warranty for this free
software.  If the software is modified by someone else and passed on, we
want its recipients to know that what they have is not the original, so
that any problems introduced by others will not reflect on the original
authors' reputations.

  Finally, any free program is threatened constantly by software
patents.  We wish to avoid the danger that redistributors of a free
program will individually obtain patent licenses, in effect making the
program proprietary.  To prevent this, we have made it clear that any
patent must be licensed for everyone's free use or not licensed at all.

  The precise terms and conditions for copying, distribution and
modification follow.

		    GNU GENERAL PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. This License applies to any program or other work which contains
a notice placed by the copyright holder saying it may be distributed
under the terms of this General Public License.  The "Program", below,
refers to any such program or work, and a "work based on the Program"
means either the Program or any derivative work under copyright law:
that is to say, a work containing the Program or a portion of it,
either verbatim or with modifications and/or translated into another
language.  (Hereinafter, translation is included without limitation in
the term "modification".)  Each licensee is addressed as "you".

Activities other than copying, distribution and modification are not
covered by this License; they are outside its scope.  The act of
running the Program is not restricted, and the output from the Program
is covered only if its contents constitute a work based on the
Program (independent of having been made by running the Program).
Whether that is true depends on what the Program does.

  1. You may copy and distribute verbatim copies of the Program's
source code as you receive it, in any medium, provided that you
conspicuously and appropriately publish on each copy an appropriate
copyright notice and disclaimer of warranty; keep intact all the
notices that refer to this License and to the absence of any warranty;
and give any other recipients of the Program a copy of this License
along with the Program.

You may charge a fee for the physical act of transferring a copy, and
you may at your option offer warranty protection in exchange for a fee.

  2. You may modify your copy or copies of the Program or any portion
of it, thus forming a work based on the Program, and copy and
distribute such modifications or work under the terms of Section 1
above, provided that you also meet all of these conditions:

    a) You must cause the modified files to carry prominent notices
    stating that you changed the files and the date of any change.

    b) You must cause any work that you distribute or publish, that in
    whole or in part contains or is derived from the Program or any
    part thereof, to be licensed as a whole at no charge to all third
    parties under the terms of this License.

    c) If the modified program normally reads commands interactively
    when run, you must cause it, when started running for such
    interactive use in the most ordinary way, to print or display an
    announcement including an appropriate copyright notice and a
    notice that there is no warranty (or else, saying that you provide
    a warranty) and that users may redistribute the program under
    these conditions, and telling the user how to view a copy of this
    License.  (Exception: if the Program itself is interactive but
    does not normally print such an announcement, your work based on
    the Program is not required to print an announcement.)

These requirements apply to the modified work as a whole.  If
identifiable sections of that work are not derived from the Program,
and can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to those
sections when you distribute them as separate works.  But when you
distribute the same sections as part of a whole which is a work based
on the Program, the distribution of the whole must be on the terms of
this License, whose permissions for other licensees extend to the
entire whole, and thus to each and every part regardless of who wrote it.

Thus, it is not the intent of this section to claim rights or contest
your rights to work written entirely by you; rather, the intent is to
exercise the right to control the distribution of derivative or
collective works based on the Program.

In addition, mere aggregation of another work not based on the Program
with the Program (or with a work based on the Program) on a volume of
a storage or distribution medium does not bring the other work under
the scope of this License.

  3. You may copy and distribute the Program (or a work based on it,
under Section 2) in object code or executable form under the terms of
Sections 1 and 2 above provided that you also do one of the following:

    a) Accompany it with the complete corresponding machine-readable
    source code, which must be distributed under the terms of Sections
    1 and 2 above on a medium customarily used for software interchange; or,

    b) Accompany it with a written offer, valid for at least three
    years, to give any third party, for a charge no more than your
    cost of physically performing source distribution, a complete
    machine-readable copy of the corresponding source code, to be
    distributed under the terms of Sections 1 and 2 above on a medium
    customarily used for software interchange; or,

    c) Accompany it with the information you received as to the offer
    to distribute corresponding source code.  (This alternative is
    allowed only for noncommercial distribution and only if you
    received the program in object code or executable form with such
    an offer, in accord with Subsection b above.)

The source code for a work means the preferred form of the work for
making modifications to it.  For an executable work, complete source
code means all the source code for all modules it contains, plus any
associated interface definition files, plus the scripts used to
control compilation and installation of the executable.  However, as a
special exception, the source code distributed need not include
anything that is normally distributed (in either source or binary
form) with the major components (compiler, kernel, and so on) of the
operating system on which the executable runs, unless that component
itself accompanies the executable.

If distribution of executable or object code is made by offering
access to copy from a designated place, then offering equivalent
access to copy the source code from the same place counts as
distribution of the source code, even though third parties are not
compelled to copy the source along with the object code.

  4. You may not copy, modify, sublicense, or distribute the Program
except as expressly provided under this License.  Any attempt
otherwise to copy, modify, sublicense or distribute the Program is
void, and will automatically terminate your rights under this License.
However, parties who have received copies, or rights, from you under
this License will not have their licenses terminated so long as such
parties remain in full compliance.

  5. You are not required to accept this License, since you have not
signed it.  However, nothing else grants you permission to modify or
distribute the Program or its derivative works.  These actions are
prohibited by law if you do not accept this License.  Therefore, by
modifying or distributing the Program (or any work based on the
Program), you indicate your acceptance of this License to do so, and
all its terms and conditions for copying, distributing or modifying
the Program or works based on it.

  6. Each time you redistribute the Program (or any work based on the
Program), the recipient automatically receives a license from the
original licensor to copy, distribute or modify the Program subject to
these terms and conditions.  You may not impose any further
restrictions on the recipients' exercise of the rights granted herein.
You are not responsible for enforcing compliance by third parties to
this License.

  7. If, as a consequence of a court judgment or allegation of patent
infringement or for any other reason (not limited to patent issues),
conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot
distribute so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you
may not distribute the Program at all.  For example, if a patent
license would not permit royalty-free redistribution of the Program by
all those who receive copies directly or indirectly through you, then
the only way you could satisfy both it and this License would be to
refrain entirely from distribution of the Program.

If any portion of this section is held invalid or unenforceable under
any particular circumstance, the balance of the section is intended to
apply and the section as a whole is intended to apply in other
circumstances.

It is not the purpose of this section to induce you to infringe any
patents or other property right claims or to contest validity of any
such claims; this section has the sole purpose of protecting the
integrity of the free software distribution system, which is
implemented by public license practices.  Many people have made
generous contributions to the wide range of software distributed
through that system in reliance on consistent application of that
system; it is up to the author/donor to decide if he or she is willing
to distribute software through any other system and a licensee cannot
impose that choice.

This section is intended to make thoroughly clear what is believed to
be a consequence of the rest of this License.

  8. If the distribution and/or use of the Program is restricted in
certain countries either by patents or by copyrighted interfaces, the
original copyright holder who places the Program under this License
may add an explicit geographical distribution limitation excluding
those countries, so that distribution is permitted only in or among
countries not thus excluded.  In such case, this License incorporates
the limitation as if written in the body of this License.

  9. The Free Software Foundation may publish revised and/or new versions
of the General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

Each version is given a distinguishing version number.  If the Program
specifies a version number of this License which applies to it and "any
later version", you have the option of following the terms and conditions
either of that version or of any later version published by the Free
Software Foundation.  If the Program does not specify a version number of
this License, you may choose any version ever published by the Free Software
Foundation.

  10. If you wish to incorporate parts of the Program into other free
programs whose distribution conditions are different, write to the author
to ask for permission.  For software which is copyrighted by the Free
Software Foundation, write to the Free Software Foundation; we sometimes
make exceptions for this.  Our decision will be guided by the two goals
of preserving the free status of all derivatives of our free software and
of promoting the sharing and reuse of software generally.

			    NO WARRANTY

  11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
REPAIR OR CORRECTION.

  12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES.

		     END OF TERMS AND CONDITIONS
```

### The zlib/libpng License (Zlib)
```text
The zlib/libpng License

Copyright (C) 1995-2024 Jean-loup Gailly and Mark Adler

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
```

### OpenSSL License / Apache License 2.0 (libcrypto)
```text
OpenSSL 3.0+ License (Apache License, Version 2.0)

In Alpine Linux 3.24, the `libcrypto3` and `libssl3` libraries (version 3.5.8-r0)
are built from the OpenSSL 3.5 source tree. Since version 3.0.0, OpenSSL is licensed
under the Apache License, Version 2.0. The full text of the Apache License 2.0
is provided in the Apache License, Version 2.0 section above.

Source: https://gitlab.alpinelinux.org/alpine/aports/-/tree/3.24-stable/main/openssl
```
