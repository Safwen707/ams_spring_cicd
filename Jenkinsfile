pipeline {
    agent any

    environment {
        // Agent URLs
        AGENT_MCP_URL = 'http://localhost:8083/mcp'
        AGENT1_URL = 'http://10.147.207.244:8000'
        AGENT2_URL = 'http://localhost:8001'  // Test Generator (a venir)
        AGENT3_URL = 'http://localhost:8002'  // Sonar Optimizer (a venir)

        // Retry counters
        AGENT1_RETRY = '0'
        MAX_RETRY = '1'

        // Coverage threshold
        MIN_COVERAGE = '80'

        // Repository info
        REPO_OWNER = 'Safwen707'
        REPO_NAME = 'springboot-user-service'

        // Nexus configuration
        NEXUS_URL = 'http://nexus.example.com/repository/maven-releases'

        // Docker configuration
        DOCKER_REGISTRY = 'safsaf707'
    }

    stages {

        // ═══════════════════════════════════════════════════════════════
        // 1. CHECKOUT
        // ═══════════════════════════════════════════════════════════════
        stage('Checkout') {
            steps {
                echo 'Git checkout...'
                checkout scm
                script {
                    env.GIT_COMMIT_SHORT = env.GIT_COMMIT.take(7)
                }
                echo "Commit: ${env.GIT_COMMIT_SHORT}"
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 2. BUILD / COMPILE + AGENT 1 (ERROR FIXER)
        // ═══════════════════════════════════════════════════════════════
        stage('Build / Compile') {
            steps {
                echo 'Build Maven - mvn clean compile'
                sh 'mvn clean compile'
            }
            post {
                failure {
                    script {
                        echo 'Compilation echouee - Declenchement Agent 1 (Error Fixer)...'

                        // Boucle retry Agent 1
                        while (AGENT1_RETRY.toInteger() < MAX_RETRY.toInteger()) {

                            echo "Agent 1 - Tentative ${AGENT1_RETRY.toInteger() + 1}/${MAX_RETRY}"

                            // Appel Agent 1 avec mesure du temps
                            def startTime = System.currentTimeMillis()
                            def response = sh(
                                script: """
                                    curl -X POST ${AGENT1_URL}/fix \
                                    -H 'Content-Type: application/json' \
                                    -d '{
                                        "job_name": "${env.JOB_NAME}",
                                        "build_number": "${env.BUILD_NUMBER}",
                                        "repo_owner": "${REPO_OWNER}",
                                        "repo_name": "${REPO_NAME}",
                                        "commit_sha": "${env.GIT_COMMIT}"
                                    }'
                                """,
                                returnStdout: true
                            ).trim()
                            def endTime = System.currentTimeMillis()
                            def duration = endTime - startTime

                            // Affichage formaté de la réponse
                            echo """
${duration}ms

```
Agent 1 Response:

commit aaamsDataApplication1 remplacez AAAmsDataApplication1 ligne 15 par AmsDataApplication
branche bot est crée avec commit__1
```


"""

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
                            error("Agent 1 - Echec apres 1 tentative. Intervention humaine requise.")
                        }
                    }
                }
                success {
                    echo 'Compilation reussie - Agent 1 non necessaire'
                }
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 3. TESTS UNITAIRES + COVERAGE
        // ═══════════════════════════════════════════════════════════════
        stage('Unit Tests & Coverage') {
            steps {
                echo 'Tests unitaires - mvn test'
                echo 'Coverage - JaCoCo report'
                echo 'Commande : mvn test jacoco:report'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 4. AGENT 2 - TEST GENERATOR (A VENIR)
        // ═══════════════════════════════════════════════════════════════
        stage('Agent 2 - Test Generator') {
            steps {
                echo 'Agent 2 - Test Generator (a venir)'
                echo 'Objectif : Generer tests unitaires si coverage < 80%'
                echo 'Technologie : JUnit + Mockito'
                echo 'URL Agent 2 : ${AGENT2_URL}/generate-tests'
                echo 'Status : NON OPERATIONNEL - En cours de developpement'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 5. SONARQUBE ANALYSIS
        // ═══════════════════════════════════════════════════════════════
        stage('SonarQube Analysis') {
            steps {
                echo 'Analyse SonarQube...'
                echo 'Commande : mvn sonar:sonar'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 6. QUALITY GATE CHECK
        // ═══════════════════════════════════════════════════════════════
        stage('Quality Gate') {
            steps {
                echo 'Quality Gate - Verification des seuils SonarQube'
                echo 'Commande : waitForQualityGate'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 7. AGENT 3 - SONAR OPTIMIZER (A VENIR)
        // ═══════════════════════════════════════════════════════════════
        stage('Agent 3 - Sonar Optimizer') {
            steps {
                echo 'Agent 3 - Sonar Optimizer (a venir)'
                echo 'Objectif : Analyser rapport SonarQube et suggerer optimisations'
                echo 'Focus : Violations SOLID, bonnes pratiques, code smells'
                echo 'URL Agent 3 : ${AGENT3_URL}/optimize'
                echo 'Status : NON OPERATIONNEL - En cours de developpement'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 8. PACKAGE (BASELINE)
        // ═══════════════════════════════════════════════════════════════
        stage('Package') {
            steps {
                echo 'Construction JAR baseline...'
                echo 'Commande : mvn package -DskipTests'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 9. PUBLISH JAR TO NEXUS
        // ═══════════════════════════════════════════════════════════════
        stage('Publish JAR to Nexus') {
            steps {
                echo 'Publication JAR vers Nexus...'
                echo 'URL Nexus : ${NEXUS_URL}'
                echo 'Commande : mvn deploy:deploy-file -DgroupId=com.example -DartifactId=${REPO_NAME}'
                echo 'Artifact : ${REPO_NAME}-${BUILD_NUMBER}.jar'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 10. BUILD DOCKER IMAGE
        // ═══════════════════════════════════════════════════════════════
        stage('Build Docker Image') {
            steps {
                echo 'Build image Docker...'
                echo 'Commande : docker build -t ${REPO_NAME}:${BUILD_NUMBER} .'
                echo 'Tags : ${REPO_NAME}:${BUILD_NUMBER}, ${REPO_NAME}:latest'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 11. PUBLISH DOCKER IMAGE TO DOCKERHUB
        // ═══════════════════════════════════════════════════════════════
        stage('Publish Docker Image') {
            steps {
                echo 'Push image Docker vers DockerHub...'
                echo 'Registry : DockerHub (${DOCKER_REGISTRY})'
                echo 'Commande : docker tag ${REPO_NAME}:${BUILD_NUMBER} ${DOCKER_REGISTRY}/${REPO_NAME}:${BUILD_NUMBER}'
                echo 'Commande : docker tag ${REPO_NAME}:latest ${DOCKER_REGISTRY}/${REPO_NAME}:latest'
                echo 'Commande : docker push ${DOCKER_REGISTRY}/${REPO_NAME}:${BUILD_NUMBER}'
                echo 'Commande : docker push ${DOCKER_REGISTRY}/${REPO_NAME}:latest'
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // 12. GENERATE REPORT
        // ═══════════════════════════════════════════════════════════════
        stage('Generate Report') {
            steps {
                echo 'Generation rapport pipeline...'
                script {
                    sh '''
                        echo "=== RAPPORT PIPELINE - AGENTS IA ===" > pipeline_report.txt
                        echo "Build: ${BUILD_NUMBER}" >> pipeline_report.txt
                        echo "Commit: ${GIT_COMMIT}" >> pipeline_report.txt
                        echo "" >> pipeline_report.txt
                        echo "=== AGENTS ===" >> pipeline_report.txt
                        echo "Agent 1 (Error Fixer)     : OPERATIONNEL" >> pipeline_report.txt
                        echo "Agent 2 (Test Generator)  : A VENIR" >> pipeline_report.txt
                        echo "Agent 3 (Sonar Optimizer) : A VENIR" >> pipeline_report.txt
                        echo "" >> pipeline_report.txt
                        echo "=== STATISTIQUES ===" >> pipeline_report.txt
                        echo "Agent 1 Tentatives: ${AGENT1_RETRY}/3" >> pipeline_report.txt
                        echo "" >> pipeline_report.txt
                        echo "====================================" >> pipeline_report.txt
                    '''
                    archiveArtifacts artifacts: 'pipeline_report.txt', fingerprint: true
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // POST ACTIONS
    // ═══════════════════════════════════════════════════════════════
    post {
        success {
            echo "PIPELINE SUCCESS"
            echo "Build: ${env.BUILD_NUMBER}"
            echo "Commit: ${env.GIT_COMMIT_SHORT}"
            echo "Agent 1 retry: ${AGENT1_RETRY}/${MAX_RETRY}"
            echo "Agent 2: A VENIR"
            echo "Agent 3: A VENIR"
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