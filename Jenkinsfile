pipeline {
    agent {
        docker {
            // Reemplaza con la imagen Docker correcta que contiene npm
            image 'imagen-product-prowess-frontend'
            // Puedes definir un label si necesitas un nodo específico
            // label 'docker-node'
        }
    }

    stages {
        stage('Checkout') {
            steps {
                // Clona el repositorio desde GitHub
                git branch: 'feature/camilo', url: 'https://github.com/JuanCamiloBlandon/Product-Prowess-Frontend.git'
            }
        }
        
        stage('Build') {
            steps {
                 sh 'docker build -t imagen-product-prowess-frontend .'
                 
            }
        }

        stage('Run') {
            sh 'docker run -d -p 80:80 --name contenedor-product-prowess-frontend imagen-product-prowess-frontend'
        }
        
        stage('Test') {
            steps {
                // Ejecuta las pruebas
                sh 'npm test'
            }
        }
    }

    post {
        success {
            // Acciones en caso de éxito
            echo 'Build and tests were successful!'
        }

        failure {
            // Acciones en caso de fallo
            echo 'Build or tests failed.'
        }

        always {
            // Acciones que siempre se ejecutan
            cleanWs()  // Limpiar el espacio de trabajo
        }
    }
}
