pipeline {
    agent any

    environment {
        ACR_NAME = "acrterraformproductprowess"  // Nombre del ACR (en minúsculas)
        ACR_LOGIN_SERVER = "${ACR_NAME}.azurecr.io"  // Login Server del ACR
        DOCKER_IMAGE = "product-prowess-frontend"
        DOCKER_TAG = "latest"
        DOCKER_CONTAINER = "contenedor-product-prowess-frontend"

        stages {
            stage('Build Docker Image') {
                steps {
                    script {
                        // Construir la imagen Docker desde el Dockerfile en el directorio actual
                        sh "docker build -t ${DOCKER_IMAGE_NAME}:${IMAGE_TAG} ."
                    }
                }
            }

            stage('Login to ACR') {
                steps {
                    script {
                        // Iniciar sesión en el Azure Container Registry (ACR)
                        sh "az acr login --name ${ACR_NAME}"
                    }
                }
            }

            stage('Tag Docker Image') {
                steps {
                    script {
                        // Etiquetar la imagen con el servidor de ACR
                        sh "docker tag ${DOCKER_IMAGE_NAME}:${IMAGE_TAG} ${ACR_LOGIN_SERVER}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }

            stage('Push Docker Image to ACR') {
                steps {
                    script {
                        // Hacer push de la imagen al ACR
                        sh "docker push ${ACR_LOGIN_SERVER}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }
        /*
        stage('Deploy') {
            steps {
                script {
                    // Detener el contenedor si está en ejecución
                    bat "docker stop ${DOCKER_CONTAINER} || exit 0"
                    
                    // Eliminar el contenedor si existe
                    bat "docker rm ${DOCKER_CONTAINER} || exit 0"
                    
                    // Crear y ejecutar el nuevo contenedor
                    bat "docker run -d --name ${DOCKER_CONTAINER} -p 80:80 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
    }
    */

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

}