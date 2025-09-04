pipeline {
    environment {
        DOCKERHUB_CREDENTIALS = credentials('safsafDockerHub')
    }

    agent any

    stages {
        stage('Création image Docker') {
            steps {
                echo 'Construction de l image Docker...'
                sh 'docker build -t safwen_amsdata_2025 .'
                echo 'Image créée avec succès'
            }
        }

        stage('Lancement de la stack Docker-compose') {
            steps {
                echo 'Arrêt de la stack existante...'
                sh 'docker compose -f Docker-compose.yml down || true'

                echo 'Démarrage de la nouvelle stack...'
                sh 'docker compose -f Docker-compose.yml up -d'

                echo 'Vérification du statut des conteneurs...'
                sh 'docker compose -f Docker-compose.yml ps'
            }
        }

        stage('tag and push image to dockerhub') {
            steps {
                echo "tag and push image ..."
                sh "docker tag safwen_amsdata_2025 safsaf707/safwen_amsdata_2025"
                sh "docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PWS"
                sh "docker push safsaf707/safwen_amsdata_2025"
                sh "docker logout"
            }
        }
    }

    post {
        success {
            echo 'Pipeline exécutée avec succès!'
            echo 'Application accessible sur: http://localhost:8099'
            echo 'phpMyAdmin accessible sur: http://localhost:8088'
            echo "====++++success++++===="
        }
        failure {
            echo 'Échec de la pipeline'
            echo "====++++failed++++===="
            sh 'docker compose -f Docker-compose.yml logs || true'
        }
    }
}