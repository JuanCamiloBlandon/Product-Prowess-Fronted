pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "product-prowess-frontend"
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                // Clona el repositorio de GitHub
                git branch: 'feature/camilo', url: 'https://github.com/JuanCamiloBlandon/Product-Prowess-Frontend.git'
            }
        }
      
        stage('Build Docker Image') {
            steps {
                script {
                    // construye la imagen Docker
                    bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Detener el contenedor si está en ejecución
                    bat """
                        docker stop contenedor-product-prowess-frontend || true
                    """
                    
                    // Eliminar el contenedor si existe
                    bat """
                        docker rm contenedor-product-prowess-frontend || true
                    """
                    
                    // Crear y ejecutar el nuevo contenedor
                    bat """
                        docker run -d --name contenedor-product-prowess-frontend -p 80:80 ${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                }
            }
        }

    post {
        always {
            // Limpia los contenedores y las imágenes después de la ejecución
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
