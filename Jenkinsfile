// https://www.jenkins.io/doc/tutorials/build-a-python-app-with-pyinstaller/
// https://www.jenkins.io/doc/pipeline/examples/

pipeline {
    agent any
    stages {
        // build
        stage('Build') {
            agent {
                docker {
                    image 'python:2-alpine'
                }
            }
            steps {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            }
        }
        // test
        stage('Test') {
            agent {
                docker {
                    image 'qnib/pytest'
                }
            }
            steps {
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            }
            post {
                always {
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

        // Deploy
        stage('Deploy') { 
            agent {
                docker {
                    image 'python:3.9'
                    args '--user root'
                }
            }
            steps {
                sh "pip install pyinstaller"
                sh "pyinstaller --onefile sources/add2vals.py" 
                sleep(time:1, unit: "MINUTES")
            }
            post {
                success {
                    archiveArtifacts 'dist/add2vals' 
                }
            }
        }
    }
}