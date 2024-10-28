pipeline {
    agent any

    environment {
        ACR_NAME = "acrterraformproductprowess"  // Nombre del ACR (en minúsculas)
        ACR_LOGIN_SERVER = "acrterraformproductprowess.azurecr.io"  // Login Server del ACR
        DOCKER_IMAGE = "product-prowess-frontend"
        DOCKER_TAG = "latest"
        DOCKER_CONTAINER = "contenedor-product-prowess-frontend"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'feature/camilo', url: 'https://github.com/JuanCamiloBlandon/Product-Prowess-Frontend.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Login to ACR') {
            steps {
                script {
                    bat "az acr login --name ${ACR_NAME}"
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                script {
                    bat "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${ACR_LOGIN_SERVER}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                script {
                    bat "docker push ${ACR_LOGIN_SERVER}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    bat "terraform init"
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    bat "terraform plan -out=tfplan"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    bat "terraform apply -auto-approve"
                }
            }
        }
    }

    post {
        always {
            bat 'docker system prune -f'
        }
        success {
            echo 'Build and deployment successful!'
        }
        failure {
            echo 'Build or deployment failed!'
        }
    }
}
