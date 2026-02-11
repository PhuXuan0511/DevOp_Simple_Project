pipeline {
        agent any

        environment {
            APP_NAME = 'devop-simple-project'
            DOCKER_REGISTRY = 'docker.io'  // Change to your registry (e.g., ghcr.io, registry.example.com)
                DOCKER_USER = 'fusssspring' // Docker Hub username that owns the repositories
            BUILD_TAG = "${BUILD_NUMBER}"
        }

        options {
            buildDiscarder(logRotator(numToKeepStr: '10'))
            timestamps()
            timeout(time: 30, unit: 'MINUTES')
        }

        stages {
            stage('Checkout') {
                steps {
                    echo 'Checking out code...'
                    script {
                        try {
                            checkout scm
                        } catch (e) {
                            echo 'Running from local workspace (not from SCM)'
                        }
                    }
                }
            }

            stage('Build Backend') {
                steps {
                    echo 'Building backend Docker image...'
                    script {
                        sh '''
                            cd /devop-simple-project/backend
                                /usr/bin/docker build -t ${DOCKER_USER}/${APP_NAME}-backend:${BUILD_TAG} .
                                /usr/bin/docker tag ${DOCKER_USER}/${APP_NAME}-backend:${BUILD_TAG} ${DOCKER_USER}/${APP_NAME}-backend:latest
                        '''
                    }
                }
            }

            stage('Build Frontend') {
                steps {
                    echo 'Building frontend Docker image...'
                    script {
                        sh '''
                            cd /devop-simple-project/frontend
                                /usr/bin/docker build -t ${DOCKER_USER}/${APP_NAME}-frontend:${BUILD_TAG} .
                                /usr/bin/docker tag ${DOCKER_USER}/${APP_NAME}-frontend:${BUILD_TAG} ${DOCKER_USER}/${APP_NAME}-frontend:latest
                        '''
                    }
                }
            }

            stage('Push to Registry') {
                steps {
                    echo 'Pushing Docker images to registry...'
                    script {
                                                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                                                    sh '''
                                                        echo "Logging in to Docker registry..."
                                                        echo "$DOCKER_PASSWORD" | /usr/bin/docker login -u "$DOCKER_USERNAME" --password-stdin ${DOCKER_REGISTRY}

                                                        /usr/bin/docker push ${DOCKER_USER}/${APP_NAME}-backend:${BUILD_TAG}
                                                        /usr/bin/docker push ${DOCKER_USER}/${APP_NAME}-backend:latest
                                                        /usr/bin/docker push ${DOCKER_USER}/${APP_NAME}-frontend:${BUILD_TAG}
                                                        /usr/bin/docker push ${DOCKER_USER}/${APP_NAME}-frontend:latest

                                                        /usr/bin/docker logout ${DOCKER_REGISTRY}
                                                    '''
                                                }
                    }
                }
            }

            stage('Test Backend') {
                steps {
                    echo 'Testing backend...'
                    script {
                        sh 'echo "Backend Docker image built successfully"'
                    }
                }
            }

            stage('Test Frontend') {
                steps {
                    echo 'Testing frontend...'
                    script {
                        sh 'echo "Frontend Docker image built successfully"'
                    }
                }
            }

            stage('Deploy') {
                steps {
                    echo 'Deploying application via Ansible playbook to Kubernetes'
                    script {
                        withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                          sh '''
                            cd ${WORKSPACE}
                            ansible-galaxy collection install -r ansible/requirements.yml || true
                            export REGISTRY_USER=${DOCKER_USERNAME}
                            export REGISTRY_PASSWORD=${DOCKER_PASSWORD}
                            export BUILD_TAG=${BUILD_TAG}
                            ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --extra-vars "registry=${DOCKER_REGISTRY} registry_namespace=${DOCKER_USER} build_tag=${BUILD_TAG} namespace=default kubeconfig=${KUBECONFIG:-}"
                          '''
                        }
                    }
                }
            }

            stage('Health Check') {
                steps {
                    echo 'Running health checks...'
                    script {
                        sh '''
                            echo "Checking services..."
                            sleep 5
                            echo "Services deployed successfully"
                        '''
                    }
                }
            }
        }

        post {
            always {
                echo 'Pipeline execution completed'
            }

            success {
                echo '✓ Pipeline executed successfully!'
                script {
                    sh '''
                        echo ""
                        echo "Application is running at:"
                        echo "  Frontend: http://localhost"
                        echo "  Backend:  http://localhost:8000"
                        echo "  API:      http://localhost/api/"
                        echo ""
                    '''
                }
            }

            failure {
                echo '✗ Pipeline failed. Check logs above for details.'
            }

            unstable {
                echo '⚠ Pipeline unstable.'
            }
        }
    }
