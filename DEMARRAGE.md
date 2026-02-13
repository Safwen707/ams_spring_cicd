# Guide de démarrage rapide - Application AMS

## 🚀 Commandes Maven correctes

### Pour exécuter l'application Spring Boot :
```bash
mvn spring-boot:run
```

OU utilisez le script fourni :
```bash
./run.sh
```

### Autres commandes Maven utiles :

#### Compiler le projet :
```bash
mvn compile
```

#### Nettoyer et construire le projet :
```bash
mvn clean install
```

#### Construire sans exécuter les tests :
```bash
mvn clean install -DskipTests
```

#### Créer un fichier JAR :
```bash
mvn package
```

#### Exécuter les tests :
```bash
mvn test
```

## 🗄️ Configuration de la base de données MySQL

L'application nécessite MySQL pour fonctionner. Vous avez trois options :

### Option 1 : Utiliser MySQL local (recommandé pour le développement)

```bash
# Installer MySQL
sudo apt-get update
sudo apt-get install mysql-server

# Démarrer MySQL
sudo systemctl start mysql

# Se connecter à MySQL
sudo mysql

# Créer la base de données et l'utilisateur (optionnel, Spring le fait automatiquement)
CREATE DATABASE IF NOT EXISTS dbams2024;
```

### Option 2 : Utiliser Docker Compose

```bash
# Démarrer tous les services (MySQL + application)
docker-compose -f Docker-compose.yml up -d

# Arrêter les services
docker-compose -f Docker-compose.yml down
```

### Option 3 : Utiliser Docker directement pour MySQL

```bash
docker run -d --name mysql_cont \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=dbams2024 \
  -e MYSQL_USER=sip \
  -e MYSQL_PASSWORD=sip-ac2024 \
  -p 3306:3306 \
  mysql:latest
```

## 📝 Configuration

Les paramètres de connexion à la base de données sont dans :
`src/main/resources/application.properties`

Configuration par défaut :
- **URL** : `jdbc:mysql://127.0.0.1:3306/dbams2024`
- **Utilisateur** : `root`
- **Mot de passe** : (vide)
- **Port** : 8080

## 🌐 Accès à l'application

Une fois l'application démarrée, accédez-y via :
- **Application** : http://localhost:8080
- **PhpMyAdmin** (si Docker Compose) : http://localhost:8083

## 🐛 Résolution des problèmes

### Erreur : "Communications link failure"
➡️ MySQL n'est pas démarré. Utilisez l'une des options ci-dessus pour démarrer MySQL.

### Erreur : "Unknown lifecycle phase 'run'"
➡️ Utilisez `mvn spring-boot:run` au lieu de `mvn run`

### Erreur : "Unknown lifecycle phase 'build'"
➡️ Utilisez `mvn package` ou `mvn install` au lieu de `mvn build`

### Port 8080 déjà utilisé
```bash
# Trouver le processus qui utilise le port 8080
sudo lsof -i :8080

# Arrêter le processus
kill -9 <PID>
```

## 📦 Construction de l'image Docker

```bash
# Construire l'image
docker build -t ams_spring_app .

# Exécuter le conteneur
docker run -p 8080:8080 ams_spring_app
```

## 🔧 Développement

L'application utilise Spring Boot DevTools, donc les modifications de code sont automatiquement rechargées.

Bonne chance ! 🎉
