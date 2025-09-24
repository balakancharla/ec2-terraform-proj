pipeline {
    agent {
        kubernetes {
            label 'terraform'
            defaultContainer 'terraform'
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: terraform
      image: hashicorp/terraform:1.5.0
      command:
        - cat
      tty: true
      volumeMounts:
        - name: workspace-volume
          mountPath: /home/jenkins/agent

    - name: jnlp
      image: jenkins/inbound-agent:latest
      env:
        - name: JENKINS_URL
          value: "http://172.19.130.166:8080/"  # Make sure this is reachable from K3s pod
      volumeMounts:
        - name: workspace-volume
          mountPath: /home/jenkins/agent
  volumes:
    - name: workspace-volume
      emptyDir: {}
'''
        }
    }

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Choose your environment')
    }
    environment {
        AWS_DEFAULT_REGION = 'us-east-2'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Select Workspace') {
            steps {
                sh "terraform workspace select ${ENV} || terraform workspace new ${ENV}"
                }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Approve to apply changes?'
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
