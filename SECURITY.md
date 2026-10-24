# Security policy / Politique de sécurité (proposition pour aadsec-public/SECURITY.md)
Version d'évaluation du 24/10/2026. Contact : contact@aadsec.xyz. Aucune adresse personnelle.

## English

### Reporting a vulnerability
If you find a security vulnerability in AADSec, please report it privately. Do not open public issues or discussions for sensitive findings.
- Email: contact@aadsec.xyz
- We aim to acknowledge a report within 5 business days and to give an initial status after triage.

### In scope
- The AADSec CLI (aadsec) and its commands.
- The official runner image (ghcr.io/aadieng100/aadsec-runner) and the aadsec-runner program.
- The official website (aadsec.xyz).
- The local-first isolation mechanisms (no accidental code leakage, no credential exfiltration, no container escape).

### Out of scope
- Vulnerabilities inside Gitleaks, Trivy, Semgrep CE or Checkov: report them to their maintainers, unless AADSec's invocation parameters cause the issue.
- Issues in underlying Linux or Python packages that do not affect AADSec's container isolation.
- Attacks that require local root or a manipulated Docker daemon socket.

### Rules
- Never include client source code, client results or production credentials in a report. Use synthetic cases or the public demo repository.
- Test only on your own machine with test workspaces or demo projects. Do not target third-party systems.
- There is no paid bug bounty at this stage. We acknowledge responsible disclosures in security advisories on request.

## Français

### Signaler une vulnérabilité
Si vous trouvez une vulnérabilité de sécurité dans AADSec, signalez-la en privé. N'ouvrez pas de ticket ni de discussion publique pour un constat sensible.
- E-mail : contact@aadsec.xyz
- Nous visons un accusé de réception sous 5 jours ouvrés et un premier état après tri.

### Périmètre
- Le CLI AADSec (aadsec) et ses commandes.
- L'image officielle du runner (ghcr.io/aadieng100/aadsec-runner) et le programme aadsec-runner.
- Le site officiel (aadsec.xyz).
- Les mécanismes d'isolation local-first (pas de fuite accidentelle de code, pas d'exfiltration d'identifiants, pas d'évasion de conteneur).

### Hors périmètre
- Les vulnérabilités de Gitleaks, Trivy, Semgrep CE ou Checkov : signalez-les à leurs mainteneurs, sauf si les paramètres d'appel d'AADSec en sont la cause.
- Les problèmes de paquets Linux ou Python sous-jacents qui n'affectent pas l'isolation du conteneur d'AADSec.
- Les attaques qui supposent un accès root local ou un socket Docker manipulé.

### Règles
- N'incluez jamais de code source client, de résultats clients ni d'identifiants de production dans un signalement. Utilisez des cas synthétiques ou le dépôt de démonstration public.
- Testez uniquement sur votre machine, avec des espaces de test ou des projets de démonstration. Ne ciblez aucun système tiers.
- Il n'y a pas de prime financière à ce stade. Les divulgations responsables sont reconnues dans les avis de sécurité, sur demande.
