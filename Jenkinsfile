node {
    stage('Checkout') {
        checkout scm
    }

    docker.image('python:3.9').inside {
        // Build Stage
        stage('Build') {
            sh 'pip install py_compile'
            sh 'python -m py_compile ./sources/add2vals.py ./sources/calc.py'
        }

        // Test Stage
        stage('Test') {
            try {
                sh "pip install pytest"
                sh 'pytest --verbose --junit-xml test-reports/results.xml ./sources/test_calc.py'
            } catch (err) {
                echo "Caught: ${err}"
                currentBuild.result = 'FAILURE'
            } finally {
                junit 'test-reports/results.xml'
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
            try {
                sh "pip install pyinstaller"
                sh "pyinstaller --onefile sources/add2vals.py"
                sleep(time:1, unit: "MINUTES")

                // Artifacts
                archiveArtifacts 'dist/add2vals'
            } catch (err) {
                echo "Caught: ${err}"
                currentBuild.result = 'FAILURE'
            }
        }
    }
}