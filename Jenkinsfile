pipeline {
    agent any
    
    environment {
        DOCKERHUB_USER = 'zhuravlenko'  // Заміни на свій логін DockerHub
        REPO_NAME      = 'jenkins-lab'          // Назва репозиторію, яку ти створив на DockerHub
        CREDENTIALS_ID = 'dockerhub_pass'       // ID твоїх Credentials з Кроку 3 у Jenkins
    }

    stages {
        stage('Start') {
            steps {
                echo "Ініціалізація збірки. Поточний номер білду: ${env.BUILD_NUMBER}"
            }
        }
        
        // НАШ НОВИЙ ДОДАНИЙ СТEЙДЖ (Кастомізація пайплайну)
        stage('Validate HTML') {
            steps {
                echo "Перевірка синтаксису index.html..."
                sh "grep -q '</html>' index.html"
                echo "Валідація пройдена успішно!"
            }
        }
        
        stage('Image Build') {
            steps {
                echo "Збірка Docker-образу..."
                sh "docker build -t ${DOCKERHUB_USER}/${REPO_NAME}:latest ."
                sh "docker tag ${DOCKERHUB_USER}/${REPO_NAME}:latest ${DOCKERHUB_USER}/${REPO_NAME}:${env.BUILD_NUMBER}"
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                echo "Авторизація та завантаження образу на DockerHub..."
                withCredentials([usernamePassword(credentialsId: "${CREDENTIALS_ID}", usernameVariable: 'USER', passwordVariable: 'TOKEN')]) {
                    sh "echo '${TOKEN}' | docker login -u '${USER}' --password-stdin"
                    sh "docker push ${DOCKERHUB_USER}/${REPO_NAME}:latest"
                    sh "docker push ${DOCKERHUB_USER}/${REPO_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
        
        stage('Deploy Image') {
            steps {
                echo "Очищення старих ресурсів та деплой нового контейнера..."
                sh '''
                docker stop my-nginx-container || true
                docker rm my-nginx-container || true
                docker run -d -p 80:80 --name my-nginx-container ${DOCKERHUB_USER}/${REPO_NAME}:latest
                '''
                echo "Деплой завершено! Сайт доступний на порту 80."
            }
        }
    }
}
