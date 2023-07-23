pipeline {
    agent any
    environment{
        image_name="036104832939.dkr.ecr.eu-central-1.amazonaws.com/flaskapp"
        region="eu-central-1"
    }
    stages{
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
                    sh "aws ecr get-login-password --region $region | docker login --username AWS --password-stdin 036104832939.dkr.ecr.eu-central-1.amazonaws.com"
                    sh "docker push $image_name:$commit_tag"
                }
            }
        }
        stage("Deploy"){
            steps {
                script {
                    sh "helm upgrade flask helm/ --install --set image=$image_name:$commit_tag --wait --atomic"
                }
            }
        }
    }
}