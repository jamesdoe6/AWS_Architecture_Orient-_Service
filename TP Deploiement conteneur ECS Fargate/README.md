# TP Deploiement conteneur ECS Fargate

## Statut : terminé

## Ressources créées
- Dépôt ECR : jeremie-server-tp1
- Cluster ECS Fargate : jeremie-cluster
- Task definition : jeremie-server-tp1 (rev. 1), rôle d'exécution ecsTaskExecutionRole
- Service ECS : jeremie-web-svc (1 tâche RUNNING)
- Security group restreint (port 80, IP personnelle uniquement) : sg-072d5dde7d2b4d182

## Sécurité
Scan Trivy réalisé sur l'image nginxdemos/hello avant push : plusieurs CVE
CRITICAL/HIGH détectées (openssl, pcre2) car image de démo non maintenue.
Décision : conservée pour le TP pédagogique, accès réseau strictement limité
à l'IP de l'opérateur. Voir trivy-scan-nginxdemos-hello.txt.

## Constat
Contrairement à l'instance EC2 brute (module Terraform compute), aucun
"explicit deny" IAM n'a été rencontré ici sur ecs:CreateService, ec2:CreateSecurityGroup
ou iam:CreateRole — le blocage EC2 précédent semble donc spécifique à ec2:RunInstances.
