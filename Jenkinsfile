pipeline {
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhubsip')
    }
    agent any
    stages {
        stage('Salutation à tout le monde devops') {
            steps {
                echo 'Bonjour tout le monde'
            }
        }
        stage('Début du pipeline ...') {
            steps {
                echo 'Chargement'
            }
        }
        stage('Création image Docker') {
            steps {
                sh 'docker build -t mezghich_ams_2024 .'
            }
        }
        stage('tag and push image to dockerhub') {
            steps {
                echo "tag and push image ..."
                sh "docker tag mezghich_ams_2024 dockerhubsip/mezghich_ams_2024"
                sh "docker login -u $DOCKERHUB_CREDENTIALS_USR -p      $DOCKERHUB_CREDENTIALS_PSW"
                sh "docker push dockerhubsip/mezghich_ams_2024"
                sh "docker logout"
            }
            post {
                success {
                    echo "====++++success++++===="
                }
                failure {
                    echo "====++++failed++++===="
                }
            }
        }
        stage('Lancement Stack Docker-Compose') {
            steps {
                sh 'docker compose -f Docker-compose.yml up -d'
            }
        }
    }
}

