pipeline {
    agent any
    environment {
        NETLIFY_SITE_ID = '411c23f4-c34c-4b20-853b-49253bcfb0f7'
        NETLIFY_AUTH_TOKEN = credentials('netlify-token')
    }
    stages {
        stage('Build Docker Image') {
            agent any
            steps {
                script {
                    sh('docker build -t my-node-app .')
                }
            }
        }
        stage('AWS'){
            agent {
                docker{
                    image 'amazon/aws-cli'
                    args "--entrypoint=''"
                }
            }
            steps{
                withCredentials([usernamePassword(credentialsId: '92b2ccb3-56a0-4ed2-955c-39128e3046a0', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                    aws --version
                    aws s3 ls
                    '''
                }                
            }
        }
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
                            image 'my-node-app'
                            reuseNode true
                        }
                    }
                    steps{
                        echo 'Running E2E Test Cases...'
                        sh '''
                        serve -s build &
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
                    image 'my-node-app'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    echo "Deploying the project to Staging.. Site ID: ${NETLIFY_SITE_ID}"
                    netlify --version
                    netlify status
                    netlify deploy --dir=build --json > deploy-output.json
                    jq -r '.deploy_url' deploy-output.json
                '''
            }
        }        
        // stage('Approval'){
        //     steps{
        //         timeout(time: 1, unit: 'MINUTES') {
        //             input message: 'Ok to proceed with production build?', ok: 'Release to Production'
        //         }
        //     }
        // }         
        stage('Deploy Prod') {
            agent{
                docker{
                    image 'my-node-app'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    echo "Deploying the project to Production.. Site ID: ${NETLIFY_SITE_ID}"
                    netlify --version
                    netlify status
                    netlify deploy --dir=build --prod --json > deploy-output.json
                    jq -r '.deploy_url' deploy-output.json
                '''
            }
        }
    }
}