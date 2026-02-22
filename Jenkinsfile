pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: jenkins-kaniko
spec:
  serviceAccountName: jenkins-sa
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:v1.16.0-debug
      imagePullPolicy: Always
      command:
        - sleep
      args:
        - 99d
    - name: git
      image: alpine/git
      command:
        - sleep
      args:
        - 99d
    - name: python
      image: python:3.11-slim
      command:
        - sleep
      args:
        - 99d
    - name: trivy
      image: aquasec/trivy:latest
      command:
        - sleep
      args:
        - 99d
    - name: aws-cli
      image: amazon/aws-cli:latest
      command:
        - sleep
      args:
        - 99d
"""
    }
  }


  environment {
    ECR_REGISTRY = "849990178824.dkr.ecr.eu-west-1.amazonaws.com" 
    IMAGE_NAME   = "goit-lern-nkos-lesson-8-9-ecr"
    IMAGE_TAG    = "${BUILD_NUMBER}"

    COMMIT_EMAIL = "jenkins@localhost"
    COMMIT_NAME  = "jenkins"
  }

  stages {
    stage('Build & Push Docker Image') {
      steps {
        container('kaniko') {
          sh '''
            /kaniko/executor \
              --context `pwd`/my_django_project \
              --dockerfile `pwd`/my_django_project/Dockerfile \
              --destination=$ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG \
              --cache=true \
              --insecure \
              --skip-tls-verify
          '''
        }
      }
    }

    stage('Update Chart Tag in Git') {
      steps {
        container('git') {
          withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PAT')]) {
            sh '''
              git clone -b lesson-8-9 https://$GIT_USERNAME:$GIT_PAT@github.com/NKostyaN/goit-devops-lerning.git goit-devops-lerning
              cd goit-devops-lerning

              sed -i "s/tag: .*/tag: $IMAGE_TAG/" charts/django-app/values.yaml

              git config user.email "$COMMIT_EMAIL"
              git config user.name "$COMMIT_NAME"

              git add charts/django-app/values.yaml
              git commit -m "Update image tag to $IMAGE_TAG"
              
              git push origin lesson-8-9
            '''
          }
        }
      }
    }
  }
}
