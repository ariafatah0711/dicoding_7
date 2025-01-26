// https://www.jenkins.io/doc/tutorials/build-a-python-app-with-pyinstaller/
// https://www.jenkins.io/doc/pipeline/examples/

pipeline {
    environment {
        EC2_USER = 'app_python'
        EC2_IP = '18.215.145.93'
        // PEM_FILE = './key/id_rsa'
    }
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
                    // Reports
                    junit 'test-reports/results.xml'
                }
            }
        }
        // Manual Approval
        stage('Manual Approval') {
            steps {
                input message: 'Lanjutkan ke tahap Deploy?'
            }
        }

        // Deploy Stage
        stage('Deploy') { 
            steps {
                sh "pip install pyinstaller"
                sh "pyinstaller --onefile sources/add2vals.py" 
                // sleep(time:1, unit: "MINUTES")

                // sh "apt install sshpass scp -y"
            }
            post {
                success {
                    // Artifacts
                    archiveArtifacts 'dist/add2vals'

                    // deploy to ec2
                    // scp -i $PEM_FILE dist/add2vals.py $EC2_USER@$EC2_IP:/home/app_python
                    sh "sshpass -p 'YXJpYQo=' scp dist/add2vals.py $EC2_USER@$EC2_IP:/home/$EC2_USER"
                }
            }
        }
    }
}