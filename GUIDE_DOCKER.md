# 🐳 Guide Docker - Application AMS Spring

## 📦 Construction de l'image Docker (Build)

### Commande de base pour construire l'image :
```bash
docker build -t ams_spring_app:latest .
```

**Explication :**
- `docker build` : Commande pour construire une image Docker
- `-t ams_spring_app:latest` : Donne un nom (tag) à l'image
  - `ams_spring_app` : Nom de l'image
  - `latest` : Version/tag de l'image
- `.` : Chemin du contexte de build (répertoire actuel contenant le Dockerfile)

### Autres options utiles :
```bash
# Build avec un nom différent
docker build -t mon_app:v1.0 .

# Build sans utiliser le cache
docker build --no-cache -t ams_spring_app:latest .

# Build avec affichage détaillé
docker build --progress=plain -t ams_spring_app:latest .
```

## 🚀 Exécution du conteneur

### Lancer le conteneur seul (sans base de données) :
```bash
docker run -d --name ams_app -p 8080:8080 ams_spring_app:latest
```

**Explication :**
- `docker run` : Crée et démarre un conteneur
- `-d` : Mode détaché (background)
- `--name ams_app` : Nom du conteneur
- `-p 8080:8080` : Mapping de port (port_hote:port_conteneur)
- `ams_spring_app:latest` : Nom de l'image à utiliser

### Lancer avec variables d'environnement pour MySQL :
```bash
docker run -d \
  --name ams_app \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://host.docker.internal:3306/dbams2024 \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD= \
  ams_spring_app:latest
```

## 🔍 Commandes utiles Docker

### Voir les images disponibles :
```bash
docker images
```

### Voir les conteneurs en cours d'exécution :
```bash
docker ps
```

### Voir tous les conteneurs (même arrêtés) :
```bash
docker ps -a
```

### Voir les logs d'un conteneur :
```bash
docker logs ams_app

# Suivre les logs en temps réel
docker logs -f ams_app
```

### Arrêter un conteneur :
```bash
docker stop ams_app
```

### Démarrer un conteneur arrêté :
```bash
docker start ams_app
```

### Supprimer un conteneur :
```bash
docker rm ams_app

# Forcer la suppression d'un conteneur en cours
docker rm -f ams_app
```

### Supprimer une image :
```bash
docker rmi ams_spring_app:latest
```

### Entrer dans un conteneur en cours d'exécution :
```bash
docker exec -it ams_app sh
```

## 🐳 Utilisation avec Docker Compose

### Démarrer tous les services (App + MySQL + PhpMyAdmin) :
```bash
docker-compose -f Docker-compose.yml up -d
```

### Arrêter tous les services :
```bash
docker-compose -f Docker-compose.yml down
```

### Voir les logs de tous les services :
```bash
docker-compose -f Docker-compose.yml logs -f
```

### Reconstruire et redémarrer un service :
```bash
docker-compose -f Docker-compose.yml up -d --build app
```

## 📋 Workflow complet de développement

### 1. Construire l'image après modifications du code :
```bash
# Compiler le projet Maven
mvn clean package -DskipTests

# Construire la nouvelle image Docker
docker build -t ams_spring_app:latest .
```

### 2. Tester localement :
```bash
# Arrêter et supprimer l'ancien conteneur
docker rm -f ams_app

# Lancer le nouveau conteneur
docker run -d --name ams_app -p 8080:8080 ams_spring_app:latest

# Voir les logs
docker logs -f ams_app
```

### 3. Accéder à l'application :
- Application : http://localhost:8080
- PhpMyAdmin (si Docker Compose) : http://localhost:8083

## 🏷️ Tagging et publication sur Docker Hub

### Se connecter à Docker Hub :
```bash
docker login
```

### Tagger l'image avec votre nom d'utilisateur :
```bash
docker tag ams_spring_app:latest votre_username/ams_spring_app:latest
docker tag ams_spring_app:latest votre_username/ams_spring_app:v1.0
```

### Publier sur Docker Hub :
```bash
docker push votre_username/ams_spring_app:latest
docker push votre_username/ams_spring_app:v1.0
```

### Télécharger depuis Docker Hub :
```bash
docker pull votre_username/ams_spring_app:latest
```

## 🧹 Nettoyage

### Supprimer tous les conteneurs arrêtés :
```bash
docker container prune
```

### Supprimer toutes les images non utilisées :
```bash
docker image prune -a
```

### Nettoyer tout (conteneurs, images, volumes, réseaux) :
```bash
docker system prune -a --volumes
```

## ⚙️ Variables d'environnement importantes

Pour personnaliser la configuration Spring Boot dans Docker :

```bash
docker run -d \
  --name ams_app \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql_host:3306/dbams2024 \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD=root \
  -e SERVER_PORT=8080 \
  ams_spring_app:latest
```

## 🔗 Réseau Docker

### Créer un réseau pour connecter app et MySQL :
```bash
# Créer un réseau
docker network create ams_network

# Lancer MySQL sur ce réseau
docker run -d \
  --name mysql_db \
  --network ams_network \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=dbams2024 \
  mysql:latest

# Lancer l'app sur le même réseau
docker run -d \
  --name ams_app \
  --network ams_network \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql_db:3306/dbams2024 \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD=root \
  ams_spring_app:latest
```

## 📝 Notes importantes

1. **Build multi-stage** : Le Dockerfile utilise un build multi-stage pour optimiser la taille de l'image
2. **Port** : L'application écoute sur le port 8080 par défaut
3. **JAR name** : Le fichier JAR s'appelle `amsmvc2024.jar` (défini dans pom.xml)
4. **Base image** : Utilise `openjdk:17-jdk-alpine` pour une image légère

## 🆘 Dépannage

### L'image ne se construit pas :
```bash
# Vérifier les erreurs avec plus de détails
docker build --progress=plain --no-cache -t ams_spring_app:latest .
```

### Le conteneur ne démarre pas :
```bash
# Voir les logs d'erreur
docker logs ams_app

# Vérifier l'état du conteneur
docker inspect ams_app
```

### Problème de connexion MySQL :
```bash
# Vérifier que MySQL est accessible
docker exec -it ams_app ping mysql_host

# Tester la connexion réseau
docker network inspect ams_network
```

---

**Astuce** : Utilisez `docker-compose` pour une gestion simplifiée de tous les services ! 🎯
