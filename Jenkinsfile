pipeline {
    agent any
    environment{
        image_name="036104832939.dkr.ecr.eu-central-1.amazonaws.com/flaskapp"
        region="eu-central-1"
    }
    stages{
        stage("Login") {
            steps {
                script {
                    def awsEcrLoginCmd = "aws ecr get-login-password --region $region"
                    def dockerLoginCmd = "docker login --username AWS --password-stdin 036104832939.dkr.ecr.eu-central-1.amazonaws.com"
                    def loginCmdOutput = sh(returnStdout: true, script: awsEcrLoginCmd).trim()
                    sh "echo ${loginCmdOutput} | ${dockerLoginCmd}"
                }
            }
        }
        stage("Build"){
            steps {
                script {
                    def commit_tag = env.GIT_COMMIT ?: "latest"
                    sh "docker build -t $image_name:$commit_tag ."
                }
            }
        }
        stage("Push"){
            steps {
                script {
                    def commit_tag = env.GIT_COMMIT ?: "latest"
                    sh "docker push $image_name:$commit_tag"
                }
            }
        }
        stage("Deploy"){
            steps {
                script {
                    def commit_tag = env.GIT_COMMIT ?: "latest"
                    sh "helm upgrade flask helm/ --install --set image=$image_name:$commit_tag --wait --atomic"
                }
            }
        }
    }
}