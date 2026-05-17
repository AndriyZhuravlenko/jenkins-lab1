pipeline {
    agent any
    stages {
        stage('Start') {
            steps {
                echo 'Lab 1: nginx/custom'
            }
        }
        stage('Build nginx/custom') {
            steps {
                sh 'docker build -t nginx/custom:latest .'
            }
        }
        stage('Test nginx/custom') {
            steps {
                echo 'Pass'
            }
        }
        stage('Deploy nginx/custom') {
            steps {
                // Зупиняємо старий контейнер, якщо він уже був запущений раніше, щоб звільнити 80 порт
                sh 'docker rm -f my-nginx-container || true'
                // Запускаємо новий контейнер на 80 порту
                sh 'docker run -d --name my-nginx-container -p 80:80 nginx/custom:latest'
            }
        }
    }
}
