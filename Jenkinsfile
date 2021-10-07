pipeline {

 environment {
   PROJECT_DIR = "/app"
   REGISTRY = "danielsparta/online_ops"
   DOCKER_CREDENTIALS = "docker_auth"
   DOCKER_IMAGE = ""
 }

 agent any

 options {
   skipStagesAfterUnstable()
 }

 stages {

   stage('Cloning The Code from GIT') {
     steps {
       git url: 'https://github.com/DanielPSparta/online_ops_server.git'
     }
   }

   stage('Build image'){
     steps {
       script {
         DOCKER_IMAGE = docker.build REGISTRY
       }
     }
   }

   stage('Deploy To Docker Hub') {
     steps {
       script{
         docker.withRegistry('', DOCKER_CREDENTIALS){
           DOCKER_IMAGE.push()
         }
       }
     }
   }

   stage('Removing the docker Image') {
     steps {
       sh "docker rmi $REGISTRY"
     }
   }
 }

}
