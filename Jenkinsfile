def imageName = 'paulappz/quote-api-gateway'
def registry = '570942461061.dkr.ecr.eu-west-2.amazonaws.com' 
def region = 'eu-west-2'

node('workers'){
    stage('Checkout'){
        checkout scm
    }
    
    
        // def imageTest= docker.build("${imageName}-test", "-f Dockerfile.test .")

    stage('Tests'){
        parallel(
            'Quality Tests': {
             //   sh "docker run --rm ${imageName}-test npm run lint"
            },
            'Integration Tests': {
             //   sh "docker run --rm ${imageName}-test npm run test"
            },
            'Coverage Reports': {
             //   sh "docker run --rm -v $PWD/coverage:/app/coverage ${imageName}-test npm run coverage-html"
             //   publishHTML (target: [
             //       allowMissing: false,
             //       alwaysLinkToLastBuild: false,
             //       keepAll: true,
             //       reportDir: "$PWD/coverage",
             //       reportFiles: "index.html",
             //       reportName: "Coverage Report"
             //   ])
            }
        )
    }
    
   stage('Build'){
       sh "aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${registry}/${imageName}"
        if (env.BRANCH_NAME == 'develop') {
                sh "docker build --build-arg ENVIRONMENT=sandbox --tag ${imageName}:develop ."
                sh " docker tag ${imageName}:develop ${registry}/${imageName}:develop"
            }
        if (env.BRANCH_NAME == 'preprod') {
                sh "docker build --build-arg ENVIRONMENT=staging --tag ${imageName}:preprod ."
                sh " docker tag ${imageName}:preprod ${registry}/${imageName}:preprod"
            }

        if (env.BRANCH_NAME == 'master') {
                sh "docker build --build-arg ENVIRONMENT=production --tag ${imageName}:master ."
                sh " docker tag ${imageName}:master ${registry}/${imageName}:master"                       
            }  
    }
    
        
    stage('Push'){
         if (env.BRANCH_NAME == 'develop') {
                sh "docker push ${registry}/${imageName}:develop"
            }
         if (env.BRANCH_NAME == 'preprod') {
                sh "docker push ${registry}/${imageName}:preprod"
            }
         if (env.BRANCH_NAME == 'master') {
                sh "docker push ${registry}/${imageName}:master"
            }
    }
    
    stage('Analyze'){
    
        if (env.BRANCH_NAME == 'develop') {
                def scannedImage = "${registry}/${imageName}:develop"
            }
         if (env.BRANCH_NAME == 'preprod') {
                def scannedImage = "${registry}/${imageName}:preprod"
            }
         if (env.BRANCH_NAME == 'master') {
                sh "docker push ${registry}/${imageName}:master"
            }

            writeFile file: 'images', text: scannedImage
            anchore name: 'images'
        }

}