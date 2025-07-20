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
"""
    }
  }

  environment {
    ECR_REGISTRY = "498777148926.dkr.ecr.us-east-1.amazonaws.com"
    IMAGE_NAME   = "lesson-5-ecr"
    IMAGE_TAG    = "v1.0.${BUILD_NUMBER}"

    COMMIT_EMAIL = "jenkins@localhost"
    COMMIT_NAME  = "jenkins"
  }

  stages {
    stage('Build & Push Docker Image') {
      steps {
        container('kaniko') {
          sh '''
        /kaniko/executor \
          --context `pwd`/charts/django-app/django \
          --dockerfile `pwd`/charts/django-app/django/Dockerfile \
          --destination=$ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG \
          --cache=true \
          --insecure \
          --skip-tls-verify
          '''
        }
      }
    }
  }

    // stage('Update Chart Tag in Git') {
    //   steps {
    //     container('git') {
    //       withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: ${github_user}, passwordVariable: ${github_pat})]) {
    //         sh '''
    //           git clone https://${github_user}:${github_pat}@github.com/${github_user}/devops.git
    //           git checkout -b lesson-9
    //           cd devops/charts/django-app

    //           sed -i "s/tag: .*/tag: $IMAGE_TAG/" values.yaml

    //           git config user.email "$COMMIT_EMAIL"
    //           git config user.name "$COMMIT_NAME"

    //           git add values.yaml
    //           git commit -m "Update image tag to $IMAGE_TAG"
    //           git push origin lesson-9
    //         '''
    //       }
    //     }
    //   }
    // }

   stage('Update Chart Tag in Git') {
      steps {
        container('git') {
          withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: ${github_user}, passwordVariable: ${github_pat})]) {
            sh '''
               git clone https://${github_user}:${github_pat}@github.com/${github_user}/devops.git
              git checkout -b lesson-8-9
              cd devops/charts/django-app

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
