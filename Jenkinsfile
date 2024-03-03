pipeline 
{
    agent {
        label 'great_node'
    }

    triggers {
        pollSCM('*/5 * * * *')
    }

    stages 
    {
        stage('Build and Push Docker Image') 
        {
            steps 
            {
                script 
                {
                    def dockerImageTag = "${GIT_BRANCH}".replaceAll("^.+?/", "")

                    withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_CREDENTIALS_ID', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) 
                    {
                        {
                          sh "docker build -t flyvisit/hillel:${dockerImageTag} HW_Docker_Boyko"
                          sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                          sh "docker push flyvisit/hillel:${dockerImageTag}"
                        }
                    }
                }  
    
    
            }
        }
        
    }
}    
