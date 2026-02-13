#!/bin/bash

# Script pour démarrer l'application Spring Boot

echo "==================================="
echo "Démarrage de l'application AMS"
echo "==================================="

# Vérifier si MySQL est en cours d'exécution
if ! sudo lsof -i :3306 > /dev/null 2>&1; then
    echo "⚠️  MySQL ne semble pas être en cours d'exécution sur le port 3306"
    echo "Tentative de démarrage de MySQL..."

    # Essayer de démarrer MySQL local
    sudo systemctl start mysql 2>/dev/null

    if [ $? -eq 0 ]; then
        echo "✅ MySQL local démarré"
    else
        echo "ℹ️  Vous devez démarrer MySQL manuellement ou via Docker"
        echo "   Option 1 (local): sudo systemctl start mysql"
        echo "   Option 2 (Docker): docker-compose -f Docker-compose.yml up -d db"
    fi
else
    echo "✅ MySQL est en cours d'exécution"
fi

echo ""
echo "Démarrage de l'application Spring Boot..."
echo "L'application sera accessible sur http://localhost:8080"
echo ""

mvn spring-boot:run
