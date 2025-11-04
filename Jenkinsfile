pipeline {
  agent any

  tools {
    maven 'maven39'   // <-- pon aquí el NOMBRE que tengas en Tools (p.ej. maven39)
    jdk 'jdk11'       // <-- idem (p.ej. jdk11 o jdk17)
  }

  options {
    timestamps()
    ansiColor('xterm')
    buildDiscarder(logRotator(numToKeepStr: '15'))
    timeout(time: 30, unit: 'MINUTES')
  }

  stages {

    stage('Checkout') {
      steps {
        echo 'Clonando el repositorio...'
        // Si tu job es "Pipeline script from SCM", puedes usar: checkout scm
        git branch: 'main', url: 'https://github.com/Cristopher8049/gorest.git'
      }
    }

    stage('Build & Test (Karate)') {
      steps {
        withCredentials([
          string(credentialsId: 'GOREST_URL',    variable: 'ENV_BASE_URL'),
          string(credentialsId: 'GOREST_BEARER', variable: 'ENV_BEARER_TOKEN')
        ]) {
          sh '''
            echo "--- Creando archivo .env desde credenciales de Jenkins ---"
            printf "BASE_URL=%s\n" "$ENV_BASE_URL"       > .env
            printf "BEARER_TOKEN=%s\n" "$ENV_BEARER_TOKEN" >> .env

            echo "--- .env creado. Ejecutando pruebas Karate... ---"
            mvn -B -DskipTests=false test
          '''
        }
      }
      post {
        always {
          // Resultados para la pestaña "Test Result"
          junit allowEmptyResults: true, testResults: '**/surefire-reports/*.xml'
          // Archivar HTML de Karate
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
