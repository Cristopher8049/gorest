pipeline {
    agent any

    tools {
        maven 'Maven' 
        jdk 'Java24'  
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Clonando el repositorio...'
                git branch: 'master', url: 'https://github.com/Cristopher8049/gorest.git'
            }
        }

        stage('Build & Test') {
            steps {

                withCredentials([
                    string(credentialsId: 'GOREST_URL', variable: 'ENV_BASE_URL'),
                    string(credentialsId: 'GOREST_BEARER', variable: 'ENV_BEARER_TOKEN')
                ]) {
                    
                    bat """
                        echo "--- Creando archivo .env desde credenciales de Jenkins ---"
                        
                        rem Escribimos las variables de entorno (inyectadas por Jenkins) al archivo
                        echo BASE_URL=%ENV_BASE_URL% > .env
                        echo BEARER_TOKEN=%ENV_BEARER_TOKEN% >> .env
                        
                        echo "--- .env creado. Ejecutando pruebas Karate... ---"
                        
                        rem Tu comando original (ahora encontrará el .env)
                        mvn test
                    """
                }
            }
        }

        stage('Publicar Reporte') {
            steps {
                echo 'Publicando reporte HTML de Karate...'
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'target/karate-reports',
                    reportFiles: 'karate-summary.html',
                    reportName: 'Reporte de Pruebas Karate'
                ])
            }
        }
    }

    post {
        always {
            echo 'Pipeline finalizado — limpiando workspace.'
            cleanWs()
        }
        success {
            echo 'Pruebas Karate ejecutadas con éxito.'
        }
        failure {
            echo 'Falló alguna etapa del pipeline.'
        }
    }
}
