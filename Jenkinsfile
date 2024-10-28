pipeline {
    agent any
    environment {
        ACR_NAME = "acrterraformproductprowess"
        ACR_LOGIN_SERVER = "acrterraformproductprowess.azurecr.io"
        DOCKER_IMAGE = "product-prowess-frontend"
        DOCKER_TAG = "latest"
        IMAGE_VERSION = "" // Variable para versión dinámica
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

        stage('Push Docker Image to ACR') {
            steps {
                script {
                    bat "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${ACR_LOGIN_SERVER}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                    bat "docker push ${ACR_LOGIN_SERVER}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                script {
                    // Generar un valor aleatorio o timestamp para forzar cambios en Terraform
                    env.IMAGE_VERSION = UUID.randomUUID().toString()
                    withEnv(["IMAGE_VERSION=${env.IMAGE_VERSION}"]) {
                        bat 'terraform init'
                        bat 'terraform apply -var "image_version=${IMAGE_VERSION}" -auto-approve'
                    }
                }
            }
        }
    }

    post {
        always {
            bat 'docker system prune -f'
        }
    }
}
