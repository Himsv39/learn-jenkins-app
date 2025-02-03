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
        stage('Tests'){
            parallel{
                stage('Unit Test') {
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
                stage('E2E'){
                    agent{
                        docker{
                            image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                            reuseNode true
                        }
                    }
                    steps{
                        echo 'Running E2E Test Cases...'
                        sh '''
                        npm install serve
                        node_modules/.bin/serve -s build &
                        sleep 10
                        npx playwright test
                        '''
                    }
                }                  
            }
        }
        stage('Deploy') {
            agent{
                docker{
                    image 'node:18'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    echo 'Deploying the project..'
                    npm install netlify-cli -g
                    netlify --version
                '''
            }
        }
    }

    post{
        always{
            junit 'jest-results/junit.xml'
        }
    }
}