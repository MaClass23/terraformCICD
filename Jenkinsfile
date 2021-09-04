node
{ 
    def mavenHome = tool name: 'maven3.8.2'
    stage("SCM Clone")
    {
        git credentialsId: 'Github_credentials', url: 'https://github.com/MaClass23/maven-web-app.git'
    }

    stage("MavenBuild") {
        sh "${mavenHome}/bin/mvn clean package"
    }
    
    stage("SonarQubeReport") {
        sh "${mavenHome}/bin/mvn sonar:sonar"
    }
    stage("uploadToNexus"){
        sh "${mavenHome}/bin/mvn deploy"
    }
    stage("BuildDockerImage") {
        sh " docker build -t maclass23/mamz-fierce:3 . "
    }
    
    stage("PudhImageReg")
    {
        withCredentials([string(credentialsId: 'Dockerhub_credentials', variable: 'Dockerhub_credentials')]) {
            sh "docker login -u maclass23 -p ${Dockerhub_credentials}"
}
            sh "docker push maclass23/mamz-fierce:3"
    }
    
   stage('RemoveDockerimages')
   {
       sh 'docker rmi -f $(docker images -q)'
   } 

stage('provision server') {
      environment {
        AWS_ACCESS_KEY_ID = "AKIAR3PFWHZGRWJ427R3"
        AWS_SECRET_ACCESS_KEY = "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"
      }
      steps {
        scripts{
          dir('terraform') {
            sh "terraform init"
            sh "terraforn apply -auto-approve"
            EC2_PUBLIC_IP = sh( 
              script: "terraform output ec2_public_ip",
              returnStdout: true 
            ).trim()
        }
      }
    }
  }
  stage('deploy') {
    steps {
      scripts {
        echo "waiting for EC2 server to initialize"
        sleep(time: 90, unit: "SECONDS")

        echo 'deploying docker image to EC2...'

        def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
        def ec2Instance = "ubuntu@${EC2_PUBLIC_IP}"

        sshagent(['testkey']) {
             sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ubuntu"
             sh "scp -o StrictHostKeyChecking=no docker-compose.yml ${ec2Instance}:/home/ubuntu"
             sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
        }
      }
    }
  }
}