pipeline {
    agent any

    stages {
        stage('📂 STAGE 1: Checkout Code') {
            steps {
                echo "Код успішно отримано з репозиторію (локальна робоча директорія)."
            }
        }

        stage('🚀 STAGE 2: Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('📝 STAGE 3: Dynamic Inventory Generation') {
            steps {
                script {
                    // Створюємо чистий динамічний інвентар для Ansible
                    def inventoryContent = """
[all:vars]
ansible_connection=docker
ansible_user=root

[app_node]
lab8-app-node

[monitor_node]
lab8-monitor-node
"""
                    writeFile file: 'ansible/inventory.ini', text: inventoryContent
                    echo "✅ Динамічний інвентар ansible/inventory.ini успішно сформовано."
                }
            }
        }

        stage('🛠️ STAGE 4: Ansible Deployment') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i inventory.ini playbook.yml'
                }
            }
        }

        stage('🔍 STAGE 5: Smoke Test') {
            steps {
                echo "Очікуємо 10 секунд для повного запуску контейнерів та веб-сервісів..."
                sleep 10
                script {
                    echo "Перевірка App Node (Порт 8084)..."
                    // Робимо запит на порт хоста, який прокинутий у контейнер
                    sh 'curl -s -o /dev/null -w "%{http_code}" http://localhost:8084'
                }
            }
        }
    }

    post {
        always {
            echo "====================================================="
            echo "Пайплайн завершив роботу."
            echo "Додаток: http://localhost:8084"
            echo "Prometheus: http://localhost:9091"
            echo "Grafana: http://localhost:3001"
            echo "====================================================="
        }
    }
}
