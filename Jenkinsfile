pipeline {
    agent {
        label 'great_node'
    }

    triggers {
        pollSCM('*/5 * * * *')
    }

    stages {
        stage('Build and Push Docker Image') 
        {
            steps {
                script {
                    def dockerImageTag = "${GIT_BRANCH}".replaceAll("^.+?/", "")

                    withCredentials([usernamePassword( usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) 
                    {
                        sh "docker build -t YuriyBoyko/jenkins-app:${dockerImageTag} HW_Docker_Boyko"
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                        sh "docker push YuriyBoyko/jenkins-app:${dockerImageTag}"
                    }
                }
            }  
    
        }
        stage('Ignored') 
        {
          withChecks('Integration Tests') 
            {
            junit skipPublishingChecks: true, testResults: 'test-results.xml'
            }
        }
    }
        
}
