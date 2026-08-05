# AWS Architecture Orientée Service — Projet ECS/EKS & Kubernetes

Projet réalisé dans le cadre du module **Amazon AWS : ECS & EKS** (Mastère Cybersécurité, BC Design Systems). Il couvre le déploiement conteneurisé sur AWS ECS Fargate, l'orchestration Kubernetes locale (Minikube), l'automatisation par Makefile, et une démonstration de haute disponibilité / autoscaling.

## Structure du projet

```
.
├── Makefile                     # Point d'entrée unique (include des .mk)
├── make/
│   ├── common.mk
│   ├── ansible.mk
│   ├── docker.mk
│   ├── tools.mk
│   ├── aws.mk
│   ├── terraform.mk
│   ├── chore.mk
│   ├── normalize.mk
│   ├── kube.mk                  # Cibles Kubernetes (apply, delete, context...)
│   ├── e2e.mk                   # Test de bout en bout (get/delete/get pods)
│   └── project.mk               # Orchestration globale (make all / verify / down)
├── apps/
│   └── demo.yaml                # Deployment + Service demo-web (nginxdemos/hello)
├── platform/
│   └── hpa.yaml                 # HorizontalPodAutoscaler
├── policies/
│   └── limitrange.yaml          # Policy de gouvernance (limites CPU/mémoire)
├── monitor.py                   # Programme de supervision HTTP (boucle 0.5s)
├── TP Demonstration replicas Kubernetes (zero-downtime)/
│   └── RAPPORT-TP-replicas.md   # Rapport complet : tests, résultats, schéma d'architecture
└── TP Deploiement conteneur ECS Fargate/
    └── ...                      # Livrables du TP ECS (task-def.json, scan Trivy, README dédié)
```

## Démarrage rapide

### Prérequis

```bash
minikube status || minikube start --driver=docker
```

### Déployer l'ensemble du projet en une commande

```bash
make all
```

Cette cible enchaîne : démarrage du cluster, application des policies/HPA (`platform/`, `policies/`), déploiement des applications (`apps/`), puis affichage des preuves de fonctionnement.

### Vérifier l'état du système

```bash
make verify
```

Affiche `kubectl get nodes,pods,hpa -A`.

### Lancer le test de bout en bout (panne simulée)

```bash
make e2e.test
```

Enchaîne automatiquement : liste des pods → sélection d'un pod → suppression → nouvelle liste des pods (preuve de recréation automatique).

### Superviser le service en direct

```bash
URL=$(minikube service demo-web --url)
python3 monitor.py "$URL"
```

### Nettoyer / détruire les ressources

```bash
make down
```

Voir la section [Nettoyage](#nettoyage-complet-make-down) ci-dessous pour le détail de ce qui est supprimé et comment vérifier que tout est bien propre.

## Résultats clés

| Test | Résultat |
|---|---|
| Zero-downtime (3 replicas, suppression d'un pod) | 116/116 requêtes en succès (100 %) |
| Coupure de service (1 replica, suppression du pod) | 8-9 requêtes en échec, quelques secondes |
| Autoscaling HPA (charge CPU artificielle) | Scale automatique de 3 à 7 replicas |
| Test Makefile end-to-end | Pod recréé automatiquement en 6 secondes |

Le détail complet (méthodologie, logs, schéma d'architecture, recommandations) est disponible dans `TP Demonstration replicas Kubernetes (zero-downtime)/RAPPORT-TP-replicas.md`.

## Nettoyage complet (`make down`)

La cible `down` doit supprimer toutes les ressources créées par `make all`, afin d'éviter de laisser tourner des composants inutiles (bonne pratique de sécurité et de maîtrise des coûts).

### Ce que `down` supprime

1. Les applications (`apps/`, dont le Deployment et le Service `demo-web`).
2. La couche platform (`platform/hpa.yaml` — le HPA).
3. Les policies de gouvernance (`policies/limitrange.yaml`).
4. Arrêt du cluster Minikube.

### Vérifier que le nettoyage est complet

Avant de considérer l'environnement propre, vérifier qu'il ne reste aucune ressource orpheline :

```bash
kubectl get all -A
kubectl get hpa -A
kubectl get limitrange -A
```

Si des ressources apparaissent encore dans le namespace `default` après `make down`, les supprimer manuellement :

```bash
kubectl delete deployment,service,hpa,limitrange --all -n default
```

### Nettoyage total (optionnel, avant une remise à zéro complète)

Pour repartir sur un environnement totalement vierge (recommandé avant la soutenance finale ou en cas de comportement anormal du cluster) :

```bash
minikube delete --all --purge
```

Cette commande supprime le cluster, son cache et ses fichiers de configuration — un nouveau `minikube start` repartira alors de zéro.

## Sécurité et coûts

- Respect du principe du moindre privilège IAM sur les comptes AWS utilisés (ECS Fargate).
- Toutes les ressources AWS (cluster ECS, task definitions, services) doivent être détruites après chaque session de travail pour éviter des coûts inutiles.
- Sur Minikube, `make down` (ou `minikube delete --all --purge` pour un nettoyage total) évite de laisser tourner des conteneurs Docker inutiles sur la machine locale.

## Formateur

Boris Rose — BC Design Systems — Module Amazon AWS : ECS & EKS
