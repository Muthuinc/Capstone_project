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
                sh './build.sh'   // docker image is built      
            }
        }

        stage ('push') {
            steps{ 
               sh ' push/./push.sh '  // docker image is pushed to docker hub repo
            }
        }

        stage ('create infra') {
            when { changeset "main.tf" } // this stage will only run if there is any change in the infra configuration
            steps{ 
               script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'Avamumbai', keyFileVariable: 'SSH_KEY', usernameVariable: 'ubuntu')]) {
                        sh """ cd create
                        ./create.sh  
                        """   //  we create the infrastructure for the dev stage using the Terraform and install the required applications for the deploy stage
                    }
               }
            }
        }

        stage ('deploy') {
            steps{
               script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'Avamumbai', keyFileVariable: 'SSH_KEY', usernameVariable: 'ubuntu')]) {
                        sh "deploy/./deploy.sh  "   // deploying the application 
                    }
               }
            }
        }

        stage ('monitor') {
            steps{ 
               script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'Avamumbai', keyFileVariable: 'SSH_KEY', usernameVariable: 'ubuntu')]) {
                        sh """ cd monitor
                        ./monitor.sh 
                        """         // monitoring the application using prometheus and grafana with the help of node and blackbox exporters
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
