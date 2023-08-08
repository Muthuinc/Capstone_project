pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS secret access ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS sceret access key')
        DOCKER_CRED = credentials('Docker')
         GIT_COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
    }
    options {
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '2')
    }

    stages { 
        stage ('build') {
            steps {
                sh './build.sh'   // docker image is built for prod env     
            }
        }

        stage ('push') {
            steps{ 
               sh ' push/./push.sh '  // docker image is pushed to docker hub repo (private repo)
            }
        }

        stage ('create infra') {
            steps{ 
               script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'Avamumbai', keyFileVariable: 'SSH_KEY', usernameVariable: 'ubuntu')]) {
                        sh """ cd create
                        ./create.sh  
                        """   //  we create the infrastructure for the prod stage using the Terraform and install the required applications for the deploy stage
                    }
               }
            }
        }

        stage ('deploy') {
            steps{
               script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'Avamumbai', keyFileVariable: 'SSH_KEY', usernameVariable: 'ubuntu')]) {
                        sh "deploy/./deploy.sh  "   // deploying the application in the prod env
                    }
               }
            }
        }
    }

    post {
        success {
            mail bcc: '', body: 'All the stages in the pipeline has been completed, check in the jenkins master for the logs', cc: '', from: '', replyTo: '', subject: 'react app pipeline completed', to: 'smuthuramalingam97@gmail.com'
        }     
    }
}
