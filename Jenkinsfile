// https://www.jenkins.io/doc/tutorials/build-a-python-app-with-pyinstaller/
// https://www.jenkins.io/doc/pipeline/examples/

pipeline {
    environment {
        EC2_USER = 'app_python' // dont use user sudoers
        EC2_IP = 'ec2-3-93-59-151.compute-1.amazonaws.com'
        // PEM_FILE = './key/id_rsa'
        EC2_PASS = 'YXJpYQo='
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
                sleep(time:1, unit: "MINUTES")

                sh 'apt-get update && apt-get install -y sshpass sshpass openssh-client'
            }
            post {
                success {
                    // Artifacts
                    archiveArtifacts 'dist/add2vals'

                    // deploy to ec2
                    sh 'ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""'
                    sh "sshpass -p '$EC2_PASS' ssh-copy-id -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP"
                    sh "ssh $EC2_USER@$EC2_IP logger 'Mengirim file dist/add2vals ke server $EC2_USER@$EC2_IP'" // logger
                    sh "scp dist/add2vals $EC2_USER@$EC2_IP:/home/$EC2_USER"

                    // sh "sshpass -p '$EC2_PASS' scp -o StrictHostKeyChecking=no dist/add2vals $EC2_USER@$EC2_IP:/home/$EC2_USER"
                }
            }
        }
    }
}