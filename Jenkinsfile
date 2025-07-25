pipeline {
  agent {
    kubernetes {
      yaml '''
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
        - cat
      tty: true
'''
    }
  }

  environment {
    ECR_REGISTRY = '498777148926.dkr.ecr.us-east-1.amazonaws.com'
    IMAGE_NAME   = 'lesson-5-ecr'
    IMAGE_TAG    = "v1.0.${BUILD_NUMBER}"

    COMMIT_EMAIL = 'jenkins@localhost'
    COMMIT_NAME  = 'jenkins'
  }

  stages {
    stage('Build & Push Docker Image') {
      steps {
        container('kaniko') {
          sh '''
            /kaniko/executor \
              --context `pwd`/django \
              --dockerfile `pwd`/django/Dockerfile \
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
          withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh '''
              echo $USERNAME
              git clone https://$USERNAME:$PASSWORD@github.com/juliacheperis13/goit-devops-hw.git
              set -x
              cd goit-devops-hw
              git checkout lesson-8-9
              cd charts/django-app

              sed -i "s/tag: .*/tag: $IMAGE_TAG/" values.yaml

              git config user.email "$COMMIT_EMAIL"
              git config user.name "$COMMIT_NAME"

              git add values.yaml
              git commit -m "Update image tag to $IMAGE_TAG"
              git push origin lesson-8-9
            '''
          }
        }
      }
    }
  }
}
