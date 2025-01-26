// https://www.jenkins.io/doc/tutorials/build-a-python-app-with-pyinstaller/

pipeline {
    agent none
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
        // Deliver
        stage('Deliver') { 
            agent {
                docker {
                    image 'python:3.9'
                    args '--user root'
                }
            }
            steps {
                sh "pip install pyinstaller"
                sh "pyinstaller --onefile sources/add2vals.py" 
            }
            post {
                success {
                    archiveArtifacts 'dist/add2vals' 
                }
            }
        }
    }
}
