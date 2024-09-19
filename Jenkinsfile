pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "product-prowess-frontend"
        DOCKER_TAG = "latest"
        DOCKER_CONTAINER = "contenedor-product-prowess-frontend"
    }

    stages {
        stage('Checkout') {
            steps {
                // Se clona el repositorio de GitHub
                git branch: 'feature/camilo', url: 'https://github.com/JuanCamiloBlandon/Product-Prowess-Frontend.git'
            }
        }
      
        stage('Build Docker Image') {
            steps {
                script {
                    // Se construye la imagen Docker
                    bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

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

    post {
        always {
            // Limpia los contenedores y las imágenes después de la ejecuciónn
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
