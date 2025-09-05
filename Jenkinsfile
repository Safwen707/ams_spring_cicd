pipeline {
     environment {
            DOCKERHUB_CREDENTIALS = credentials('safsafDocker')
        }
    agent any
    stages {

        stage('Création image Docker 2') {
            steps {
                sh 'docker build -t safwen_amsdata_2025 .'
            }
        }
         stage('Lancement de la Stack Docker-Compose') {
                    steps {
                        sh 'docker compose -f Docker-compose.yml down'
                        sh 'docker compose -f Docker-compose.yml up -d'
                    }
         }
         stage('tag and push image to dockerhub') {
                     steps {
                         echo "tag and push image ..."
                         sh "docker tag safwen_amsdata_2025 safsaf707/safwen_amsdata_2025"
                         sh "docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW"
                         sh "docker push safsaf707/safwen_amsdata_2025"
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
    }
}
