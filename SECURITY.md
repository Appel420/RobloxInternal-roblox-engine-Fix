# Security

This repository documents child-safety and data-minimization practices for moderation and account protection systems.

## Scope

- Minimize collection and retention.
- Prefer restrictive defaults for child accounts.
- Separate automated moderation from human review.
- Keep audit trails for safety actions and deletion events.

## Operational expectations

- Restrict access to sensitive moderation data.
- Redact unnecessary personal data in logs and exports.
- Review escalation and incident handling before shipping changes.
- Treat any live deployment as requiring threat modeling and security review.
