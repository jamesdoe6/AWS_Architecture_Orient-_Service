# AWS Architecture Orientée Service

Projet de formation ECS/EKS — Automatisation via Makefile, Ansible, Docker et Terraform.

## Structure du projet

- `Docker/` — Image Docker du site web (nginx)
- `ansible/` — Playbook Ansible pour la création de répertoires
- `infra/` — Configuration Terraform (ECS/EKS)
- `make/` — Makefiles modulaires (docker, ansible, aws, terraform, tools)

## Utilisation

\`\`\`bash
make help
\`\`\`
