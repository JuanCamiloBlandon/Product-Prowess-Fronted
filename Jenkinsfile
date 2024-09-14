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
                    // Se construye la imagen Docker
                    bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }
        stage('Deploy') {
            steps {
                script {

                    bat "docker run -d -p 80:80 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
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
