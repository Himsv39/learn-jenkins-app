pipeline {
    agent any
    environment {
        NETLIFY_SITE_ID = '411c23f4-c34c-4b20-853b-49253bcfb0f7'
        NETLIFY_AUTH_TOKEN = credentials('netlify-token')
    }
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
                    echo 'small change'
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
        stage('Deploy Staging') {
            agent{
                docker{
                    image 'node:18'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    echo "Deploying the project to Staging.. Site ID: ${NETLIFY_SITE_ID}"
                    npm install netlify-cli node-jq
                    node_modules/.bin/netlify --version
                    node_modules/.bin/netlify status
                    node_modules/.bin/netlify deploy --dir=build > deploy-output.json
                    node_modules/.bin/node-jq -r '.deploy_url' deploy-output.json
                '''
            }
        }        
        stage('Approval'){
            steps{
                timeout(time: 1, unit: 'MINUTES') {
                    input message: 'Ok to proceed with production build?', ok: 'Release to Production'
                }
            }
        }         
        stage('Deploy Prod') {
            agent{
                docker{
                    image 'node:18'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    echo "Deploying the project to Production.. Site ID: ${NETLIFY_SITE_ID}"
                    npm install netlify-cli node-jq
                    node_modules/.bin/netlify --version
                    node_modules/.bin/netlify status
                    node_modules/.bin/netlify deploy --dir=build --prod > deploy-output.json
                    node_modules/.bin/node-jq -r '.deploy_url' deploy-output.json
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