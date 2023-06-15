CONFIGURATION SERVICES ET DEPLOIEMENTS

Il y a 2 types de configurations a faire pour deployer un service:
- Creer un deploiement (la premiere partie des fichiers volume-*.yaml)
- Creer le service (La deuxieme partie des fchiers volume-*.yaml)

Les parties des fichiers yaml sont separees par des "---"
Pour mettre en places les services et deploiements, on utilise la commande:

$>kubectl apply -f /data/shared/volume-<au choix>.yaml

Pour verifier que les services et deploiements sont tous bien crees on peut utiliser la commande

$>kubectl get all

_____________________________

CONFIGURATION INGRESS

Il y a plusieurs maniere de configurer le LoadBalancer 
On peut configurer Ingress, qui est le LoadBalancer basique integre avec k3s
ou bien rajouter un controleur ingress comme par exemple Traefik. Les controleurs ingress
rajoute des options et possibilites par rapport a ingress. Mais l plus part des clusters de maniere general tournent 
sous ingress donc pour plus de compatibilite il est recommande d'utiliser ingress.

Ici seul ingress est configure car il suffit a faire le travail demande.

Pour la configuration ingress, 3 regles sont specifiees:
- Le defaultBackend (en cas de requete sans precision ou host ou mauvais host)
- L'app1 (apache)
- L'app2 (wordpress)

Une fois la configuration ingress ecrite, on peut la mettre en place en utilisant la commande:

$>kubectl apply -f /data/shared/ingress-config.yaml

Il est possible d'acceder aux differents services en passant un nom d'host

Exemple: $>curl -H "Host: app1.com" 192.168.56.110

Pour decrire les regles ingress en cours, il est possible d'utiliser la commande:

$>kubectl describe ingress
