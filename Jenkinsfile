pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        timeout(time: 45, unit: 'MINUTES')
    }

    environment {
        TARGET_URL = 'http://juice-shop-lab:3000'
    }

    stages {
        stage('Check Target') {
            steps {
                sh '''
                    curl -fsS "$TARGET_URL" -o /dev/null
                    echo "Juice Shop is reachable."
                '''
            }
        }

        stage('Technology Detection') {
            steps {
                sh '''
                    mkdir -p reports

                    nuclei \
                      -u "$TARGET_URL" \
                      -t http/technologies/ \
                      -no-interactsh \
                      -rl 5 \
                      -c 2 \
                      -json-export reports/tech-scan.json

                    echo "Technology detection completed."
                '''
            }
        }

        stage('Misconfiguration Scan') {
            steps {
                sh '''
                    nuclei \
                      -u "$TARGET_URL" \
                      -tags misconfig \
                      -no-interactsh \
                      -etags dos,fuzz,intrusive \
                      -rl 10 \
                      -c 3 \
                      -json-export reports/misconfig-scan.json

                    echo "Misconfiguration scan completed."
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts(
                artifacts: 'reports/*.json',
                allowEmptyArchive: true
            )
        }
    }
}
