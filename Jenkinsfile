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
        // deploy
        stage('Deploy') {
            agent {
                docker { image 'docker:20.10' }
            }
            steps {
                sh '''
                docker build -t my-python-app .
                docker run -d -p 5000:5000 --name my-python-app-container my-python-app
                '''
            }
        }
    }
}
