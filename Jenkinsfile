pipeline {
  agent { label 'localvm' }

  environment {
    appRegistry = 'local'
  }

  stages {

   stage('build && SonarQube analysis') {
            environment {
             scannerHome = tool 'sonar4.7'
          }
            steps {
                withSonarQubeEnv('sonar') {
                 sh '''${scannerHome}/bin/sonar-scanner -X -Dsonar.projectKey=djangoproject \
                   -Dsonar.projectName=djangoproject -Dsonar.login=$SONAR_DJANGO_TOKEN '''
                }
            }
    }
   stage("Quality Gate") {
            steps {
                script{
                    timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true 
                    
                }
              }
            
            }
        }
    stage('put app env') {
      steps {
        script {
          withCredentials([file(credentialsId: 'PROJECT_A_ENV', variable: 'ENVFILE')]) {
            sh '''
            rm -rf "$WORKSPACE/.env"
            cp "$ENVFILE" "$WORKSPACE/.env"
            '''
          }
        }
      }
    }

    stage('Build App Image') {
      steps {
        script {
          dockerImage = docker.build(appRegistry + ":$BUILD_NUMBER")
        }
      }
    }

/*
 Adjust based on req. disable when using local repo

    stage('Upload App Image') {
          steps{
            script {
              docker.withRegistry( '', registryCredential ) {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
     }
*/

    stage('deploy app') {
      steps {
        sh '''
        APP_VERSION="${appRegistry}:${BUILD_NUMBER}" docker compose up -d
        '''
      }
    }

    stage('remove old image') {
      steps {
        sh '''
          OLD_TAG=$((${BUILD_NUMBER} - 3))
          if [ "$OLD_TAG" -gt 0 ]; then
            echo "Deleting old image: $appRegistry:$OLD_TAG"
            docker rmi -f "${appRegistry}:$OLD_TAG"
          else
            echo "No old image to delete yet."
          fi
        '''
      }
    }

  }
    post {
      success {
         slackSend color: "good", message: "project dev deployed successfully"
      }
      failure {
         slackSend color: "warning", message: "project dev failed to deploy"
      }
    }
}
