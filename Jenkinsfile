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
       git 'https://github.com/DanielPSparta/online_ops_server.git'
     }
   }
 }

}
