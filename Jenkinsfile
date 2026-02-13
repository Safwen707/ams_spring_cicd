pipeline {
    agent any

    environment {
        // Agent URLs
        AGENT_MCP_URL = 'http://localhost:8083/mcp'
        AGENT1_URL = 'http://localhost:8000'

        // Retry counters
        AGENT1_RETRY = '0'
        MAX_RETRY = '3'
    }

    stages {

        // ═══════════════════════════════════════════════════════════════
        // 1. CHECKOUT
        // ═══════════════════════════════════════════════════════════════
        stage('Checkout') {
            steps {
                echo 'Git checkout...'
                checkout scm
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 2. BUILD / COMPILE + AGENT 1
        // ═══════════════════════════════════════════════════════════════
        stage('Build / Compile 1') {
            steps {

                sh 'mvn clean compile'
            }
            post {
                failure {
                    script {
                        echo 'Compilation echouee - Declenchement Agent 1...'

                        // Boucle retry Agent 1
                        while (AGENT1_RETRY.toInteger() < MAX_RETRY.toInteger()) {

                            echo "Agent 1 - Tentative ${AGENT1_RETRY.toInteger() + 1}/${MAX_RETRY}"

                            // Appel Agent 1
                            def response = sh(
                                script: """
                                    curl -X POST ${AGENT1_URL}/fix \
                                    -H 'Content-Type: application/json' \
                                    -d '{
                                        "job_name": "${env.JOB_NAME}",
                                        "build_number": "${env.BUILD_NUMBER}",
                                        "repo_owner": "Safwen707",
                                        "repo_name": "springboot-user-service",
                                        "commit_sha": "${env.GIT_COMMIT}"
                                    }'
                                """,
                                returnStdout: true
                            ).trim()

                            echo "Agent 1 Response:"
                            echo response

                            writeFile file: "agent1_report_tentative_${AGENT1_RETRY}.json", text: response

                            echo 'Application du patch suggere...'

                            // Relancer la compilation
                            def compileResult = sh(script: 'mvn clean compile', returnStatus: true)

                            if (compileResult == 0) {
                                echo 'Compilation reussie apres correction Agent 1'
                                break
                            }

                            AGENT1_RETRY = (AGENT1_RETRY.toInteger() + 1).toString()
                        }

                        if (AGENT1_RETRY.toInteger() >= MAX_RETRY.toInteger()) {
                            error("Agent 1 - Echec apres ${MAX_RETRY} tentatives. Intervention humaine requise.")
                        }
                    }
                }
                success {
                    echo 'Compilation reussie pas necessaire d\'appeler Agent 1'
                }
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 3. SONARQUBE ANALYSIS
        // ═══════════════════════════════════════════════════════════════
        stage('SonarQube Analysis') {
            steps {
                echo 'Analyse SonarQube...'
                echo 'Commande : mvn sonar:sonar'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 4. RUN SONAR AI AGENT
        // ═══════════════════════════════════════════════════════════════
        stage('Run Sonar AI Agent') {
            steps {
                echo 'Agent 3 - Analyse rapport SonarQube...'
                echo 'Commande : curl -X POST AGENT3_URL/optimize'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 5. GENERATE REPORT
        // ═══════════════════════════════════════════════════════════════
        stage('Generate Report') {
            steps {
                echo 'Generation rapport Agent 1...'
                script {
                    sh '''
                        echo "=== RAPPORT PIPELINE - AGENT 1 ===" > pipeline_report.txt
                        echo "Build: ${BUILD_NUMBER}" >> pipeline_report.txt
                        echo "Commit: ${GIT_COMMIT}" >> pipeline_report.txt
                        echo "Agent 1: Error Fixer (operationnel)" >> pipeline_report.txt
                        echo "Agent 2: Test Generator (a venir)" >> pipeline_report.txt
                        echo "Agent 3: Sonar Optimizer (a venir)" >> pipeline_report.txt
                        echo "====================================" >> pipeline_report.txt
                    '''
                    archiveArtifacts artifacts: 'pipeline_report.txt', fingerprint: true
                }
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 6. PACKAGE (BASELINE)
        // ═══════════════════════════════════════════════════════════════
        stage('Package (Baseline)') {
            steps {
                echo 'Construction JAR baseline...'
                echo 'Commande : mvn package -DskipTests'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 7. PUBLISH JAR TO NEXUS
        // ═══════════════════════════════════════════════════════════════
        stage('Publish JAR to Nexus') {
            steps {
                echo 'Publication JAR vers Nexus...'
                echo 'URL Nexus : http://nexus.example.com/repository/maven-releases'
                echo 'Commande : mvn deploy:deploy-file -DgroupId=com.example -DartifactId=springboot-user-service'
                echo 'Artifact : springboot-user-service-${BUILD_NUMBER}.jar'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 8. BUILD DOCKER IMAGE
        // ═══════════════════════════════════════════════════════════════
        stage('Build Docker Image') {
            steps {
                echo 'Build image Docker...'
                echo 'Commande : docker build -t springboot-user-service:${BUILD_NUMBER} .'
                echo 'Tags : springboot-user-service:${BUILD_NUMBER}, springboot-user-service:latest'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 9. PUBLISH DOCKER IMAGE
        // ═══════════════════════════════════════════════════════════════
        stage('Publish Docker Image to DockerHub') {
            steps {
                echo 'Push image Docker vers DockerHub...'
                echo 'Registry : DockerHub (safsaf707)'
                echo 'Commande : docker tag springboot-user-service:${BUILD_NUMBER} safsaf707/springboot-user-service:${BUILD_NUMBER}'
                echo 'Commande : docker tag springboot-user-service:latest safsaf707/springboot-user-service:latest'
                echo 'Commande : docker login -u USERNAME -p PASSWORD'
                echo 'Commande : docker push safsaf707/springboot-user-service:${BUILD_NUMBER}'
                echo 'Commande : docker push safsaf707/springboot-user-service:latest'
                echo 'Commande : docker logout'
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // POST ACTIONS
    // ═══════════════════════════════════════════════════════════════
    post {
        success {
            echo "PIPELINE SUCCESS (Agent 1 operationnel)"
            echo "Build: ${env.BUILD_NUMBER}"
            echo "Agent 1 retry: ${AGENT1_RETRY}/${MAX_RETRY}"
            echo "Agents 2 & 3: a venir"
        }

        failure {
            echo "PIPELINE FAILURE"
            echo "Build: ${env.BUILD_NUMBER}"
            echo "Consulter rapports Agent 1 dans artifacts"
        }

        always {
            archiveArtifacts artifacts: 'agent1_report_*.json', allowEmptyArchive: true
            echo 'Nettoyage...'
        }
    }
}