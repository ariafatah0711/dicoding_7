node {
    stage('Checkout') {
        checkout scm
    }

    withDockerContainer('python:2-alpine') {
        stage('Build') {
            sh 'python -m py_compile ./sources/add2vals.py ./sources/calc.py'
        }
    }

    withDockerContainer('qnib/pytest') {
        try {
            stage('Test') {
                sh 'py.test --verbose --junit-xml test-reports/results.xml ./sources/test_calc.py'
            }
        } catch (err) {
            echo "Caught: ${err}"
            currentBuild.result = 'FAILURE'
        } finally {
            junit 'test-reports/results.xml'
        }
    }
}
