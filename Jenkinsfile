// node {
//     stage('Checkout') {
//         checkout scm
//     }

//     docker.image('python:3.9').inside('--user root') {
//         // Build Stage
//         stage('Build') {
//             sh 'python -m py_compile ./sources/add2vals.py ./sources/calc.py'
//         }

//         // Test Stage
//         stage('Test') {
//             try {
//                 sh "pip install pytest"
//                 sh 'pytest --verbose --junit-xml test-reports/results.xml ./sources/test_calc.py'
//             } catch (err) {
//                 echo "Caught: ${err}"
//                 currentBuild.result = 'FAILURE'
//             } finally {
//                 // report
//                 junit 'test-reports/results.xml'
//             }
//         }
//     }

//     // Manual Approval
//     stage('Manual Approval') {
//         steps {
//             input message: 'Apakah Anda ingin melanjutkan ke deploy? (Klik "Proceed" untuk Deploy)'
//         }
//     }

//     docker.image('python:3.9').inside('--user root') {
//         // Deploy Stage
//         stage('Deploy') {
//             try {
//                 sh "pip install pyinstaller"
//                 sh "pyinstaller --onefile sources/add2vals.py"
//                 sleep(time:1, unit: "MINUTES")

//                 // Artifacts
//                 archiveArtifacts 'dist/add2vals'
//             } catch (err) {
//                 echo "Caught: ${err}"
//                 currentBuild.result = 'FAILURE'
//             }
//         }
//     }
// }

node {
    stage('Checkout') {
        checkout scm
    }

    // Build dan Test Stage di dalam Docker container
    docker.image('python:3.9').inside('--user root') {
        stage('Build') {
            sh 'python -m py_compile ./sources/add2vals.py ./sources/calc.py'
        }

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
    }

    // Manual Approval dilakukan di luar Docker container
    stage('Manual Approval') {
        steps {
            input message: 'Apakah Anda ingin melanjutkan ke deploy? (Klik "Proceed" untuk Deploy)'
        }
    }

    // Deploy Stage di dalam Docker container
    docker.image('python:3.9').inside('--user root') {
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
