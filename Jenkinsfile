pipeline {
    agent {
        label 'worker-node'
    }

    environment {
        GITHUB_ACCESS_TOKEN = credentials('github-access-key')
    }

    stages {
        stage('Build and Push Docker Image') {
            steps {
                script {
                    def dockerImageTag = env.BRANCH_NAME.replaceAll("/", "-")

                    withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_CREDENTIALS_ID', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker build -t flyvisit/hillel:${dockerImageTag} HW_Docker_Boyko"
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                        sh "docker push flyvisit/hillel:${dockerImageTag}"
                    }
                }
            }
        }
    }

    post {
        success {
            script {
                currentBuild.result = 'SUCCESS'
                updateGitHubCommitStatus("success")
            }
        }
        failure {
            script {
                currentBuild.result = 'FAILURE'
                updateGitHubCommitStatus("failure")
            }
        }
    }
}

def updateGitHubCommitStatus(String status) {
    def commitSha = env.GIT_COMMIT

    def curlCommand = """
        curl -L \
        -X POST \
        -H 'Accept: application/vnd.github+json' \
        -H 'Authorization: Bearer ${GITHUB_ACCESS_TOKEN}' \
        -H 'X-GitHub-Api-Version: 2022-11-28' \
        https://api.github.com/repos/YuriyBoyko/hillel_edu/statuses/${commitSha} \
        -d '{
            "state": "${status}",
            "target_url": "${env.BUILD_URL}",
            "description": "Jenkins CI build ${status}",
            "context": "Jenkins CI"
        }'
    """

    def response = sh(script: curlCommand, returnStdout: true).trim()
    echo "Response: ${response}"
}
