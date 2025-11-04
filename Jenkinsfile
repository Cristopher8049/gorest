pipeline {
  agent any

  tools {
    maven 'maven39'   // usa EXACTAMENTE el nombre que configuraste en Tools
    jdk   'jdk11'     // idem
  }

  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '15'))
    timeout(time: 30, unit: 'MINUTES')
  }

  stages {

    // Puedes borrar este stage y dejar el checkout declarativo si usas "Pipeline from SCM"
    stage('Checkout') {
      steps {
        echo 'Clonando el repositorio...'
        git branch: 'main', url: 'https://github.com/Cristopher8049/gorest.git'
      }
    }

    stage('Build & Test') {
      steps {
        withCredentials([
          string(credentialsId: 'GOREST_URL',    variable: 'ENV_BASE_URL'),
          string(credentialsId: 'GOREST_BEARER', variable: 'ENV_BEARER_TOKEN')
        ]) {
          sh '''
            echo "--- Creando archivo .env desde credenciales de Jenkins ---"
            printf "BASE_URL=%s\n" "$ENV_BASE_URL"          > .env
            printf "BEARER_TOKEN=%s\n" "$ENV_BEARER_TOKEN" >> .env

            echo "--- .env creado. Ejecutando pruebas Karate... ---"
            mvn -B -DskipTests=false test
          '''
        }
      }
      post {
        always {
          junit allowEmptyResults: true, testResults: '**/surefire-reports/*.xml'
          archiveArtifacts artifacts: 'target/karate-reports/**', fingerprint: true
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
      echo "Pipeline finalizado — estado: ${currentBuild.currentResult}"
      cleanWs()
    }
    success { echo '✅ Pruebas Karate ejecutadas con éxito.' }
    failure { echo '❌ Falló alguna etapa del pipeline.' }
  }
}
