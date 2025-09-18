pipeline {
    agent {
        kubernetes {
            label 'terraform'
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: terraform
    image: hashicorp/terraform:1.5.0
    command:
    - cat
    tty: true
  - name: jnlp
    image: jenkins/inbound-agent:latest
    args: ['$(JENKINS_SECRET)', '$(JENKINS_NAME)']
"""
            defaultContainer 'terraform' // 👈 This line is important!
        }
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
