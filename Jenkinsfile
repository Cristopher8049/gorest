pipeline {
  agent any
  tools { maven 'maven39' }   // usa el nombre exacto que pusiste
  options { timestamps(); buildDiscarder(logRotator(numToKeepStr:'15')); timeout(time:30, unit:'MINUTES') }

  stages {
    stage('Checkout'){
      steps {
        // Si ya usas "Pipeline script from SCM", puedes omitir esta stage y dejar el checkout automático
        git branch: 'main', url: 'https://github.com/Cristopher8049/gorest.git'
      }
    }

    stage('Sanity tools'){
      steps {
        sh 'java -version || true'
        sh 'mvn -v || true'
      }
    }

    stage('Build & Test (Karate)'){
      steps {
        withCredentials([
          string(credentialsId:'GOREST_URL',    variable:'ENV_BASE_URL'),
          string(credentialsId:'GOREST_BEARER', variable:'ENV_BEARER_TOKEN')
        ]) {
          sh '''
            printf "BASE_URL=%s\n" "$ENV_BASE_URL"          > .env
            printf "BEARER_TOKEN=%s\n" "$ENV_BEARER_TOKEN" >> .env
            mvn -B -DskipTests=false test
          '''
        }
      }
      post {
        always {
          junit allowEmptyResults:true, testResults:'**/surefire-reports/*.xml'
          archiveArtifacts artifacts:'target/karate-reports/**', fingerprint:true
        }
      }
    }

    stage('Publicar Reporte'){
      steps {
        publishHTML([
          allowMissing:false, alwaysLinkToLastBuild:true, keepAll:true,
          reportDir:'target/karate-reports', reportFiles:'karate-summary.html',
          reportName:'Reporte de Pruebas Karate'
        ])
      }
    }
  }

  post {
    always { echo "Estado: ${currentBuild.currentResult}"; cleanWs() }
  }
}
