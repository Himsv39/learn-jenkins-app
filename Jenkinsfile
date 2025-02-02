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
                    npm ci
                    echo 'Started with the build process..'
                    echo 'Installing dependencies..'
                    npm install
                '''
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
}