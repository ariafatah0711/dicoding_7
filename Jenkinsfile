// https://www.jenkins.io/doc/tutorials/build-a-python-app-with-pyinstaller/
// https://www.jenkins.io/doc/pipeline/examples/

pipeline {
    agent {
        docker {
            image 'python:3.9'
            args '--user root'
        }
    }
    stages {
        // Build Stage
        stage('Build') {
            steps {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            }
        }
        // Test Stage
        stage('Test') {
            steps {
                sh 'pip install pytest'
                sh 'pytest --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            }
            post {
                always {
                    // report
                    junit 'test-reports/results.xml'
                }
            }
        }
        // Manual Approval
        stage('Manual Approval') {
            steps {
                input message: 'Apakah Anda ingin melanjutkan ke deploy? (Klik "Proceed" untuk Deploy)'
            }
        }

        // Deploy Stage
        stage('Deploy') { 
            steps {
                sh "pip install pyinstaller"
                sh "pyinstaller --onefile sources/add2vals.py" 
                sleep(time:1, unit: "MINUTES")
            }
            post {
                success {
                    // Artifacts
                    archiveArtifacts 'dist/add2vals'
                }
            }
        }
    }
}