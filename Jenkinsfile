pipeline {
    agent any

    stages {
        stage('Build') {
            agent{
                docker{
                    image 'node:18'
                    reuseNode true
                }
            }
            steps {
                echo 'Building...'
                sh '''
                    ls -la
                    node --version
                    npm --version
                    echo 'Initialising the project..'
                    npm ci
                    echo 'Started with the build process..'
                    npm run build
                    ls -la
                '''
            }
        }
        stage('Test') {
            agent{
                docker {
                    image 'node:18'
                    reuseNode true
                }
            }
            steps {
                echo 'Running Test Cses...'
                sh '''
                   test -f package.json && echo 'File exists' || echo 'File does not exist'
                   test -f build/index.html && echo 'Index.html File exists' || echo 'Index.html File does not exist'
                   node --version
                   npm --version
                   npm test a
                '''
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
}