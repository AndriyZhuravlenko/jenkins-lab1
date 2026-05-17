pipeline {
    agent any
    
    options {
        ansiColor('xterm')
    }
    
    environment {
        DOCKERHUB_USER = 'zhuravlenko' // Замініть на свій логін DockerHub
        REPO_NAME      = 'jenkins-lab'
        CREDENTIALS_ID = 'dockerhub_pass'
    }

    stages {
        stage('Code Linting') {
            steps {
                echo "\u001B[34m=== [ІНФО] Початок валідації синтаксису... ==="
                sh "grep -q '<html' index.html && echo 'Код валідний!' || (echo 'Помилка синтаксису' && exit 1)"
            }
        }
        
        stage('Image Build') {
            steps {
                echo "\u001B[32m=== [ЗБІРКА] Збираємо Docker образ для оточення: ${params.ENVIRONMENT} ==="
                sh "docker build -t ${DOCKERHUB_USER}/${REPO_NAME}:latest ."
                sh "docker tag ${DOCKERHUB_USER}/${REPO_NAME}:latest ${DOCKERHUB_USER}/${REPO_NAME}:${env.BUILD_NUMBER}"
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                echo "\u001B[34m=== [РЕЄСТР] Відправка артефакту на DockerHub... ==="
                withCredentials([usernamePassword(credentialsId: "${CREDENTIALS_ID}", usernameVariable: 'USER', passwordVariable: 'TOKEN')]) {
                    sh "echo '${TOKEN}' | docker login -u '${USER}' --password-stdin"
                    sh "docker push ${DOCKERHUB_USER}/${REPO_NAME}:latest"
                    sh "docker push ${DOCKERHUB_USER}/${REPO_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
        
        stage('Deploy Image') {
            steps {
                script {
                    if (params.ENVIRONMENT == 'production') {
                        echo "\u001B[31m⚠️ === [ДЕПЛОЙ] Увага! Старт деплою на PRODUCTION сервер! ==="
                        sh '''
                        docker stop my-nginx-container || true
                        docker rm my-nginx-container || true
                        docker run -d -p 80:80 --name my-nginx-container ${DOCKERHUB_USER}/${REPO_NAME}:latest
                        '''
                    } else {
                        echo "\u001B[33m➔ === [ДЕПЛОЙ] Режим Staging. Тестовий запуск контейнера... ==="
                        // Для тесту запускаємо на іншому порту, наприклад 8081
                        sh '''
                        docker stop my-nginx-staging || true
                        docker rm my-nginx-staging || true
                        docker run -d -p 8081:80 --name my-nginx-staging ${DOCKERHUB_USER}/${REPO_NAME}:latest
                        '''
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "================================================="
            echo "Фінальний звіт логування:"
            echo "Номер збірки: ${env.BUILD_NUMBER}"
            echo "Статус виконання: ${currentBuild.currentResult}"
            echo "Час завершення: ${new Date().toString()}"
            echo "================================================="
        }
    }
}
