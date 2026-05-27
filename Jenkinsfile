pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        stage('📂 STAGE 1: Checkout Code') {
            steps {
                echo 'Код успішно отримано з репозиторію (локальна робоча директорія).'
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
                    // Запуск плейбука з використанням створеного інвентаря
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
                    def appStatus = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:8084", returnStdout: true).trim()
                    if (appStatus == "200") {
                        echo "✅ App Node доступний (HTTP 200)"
                    } else {
                        error "❌ Помилка: App Node повернув статус ${appStatus}"
                    }

                    echo "Перевірка Monitor Node (Prometheus Порт 9091)..."
                    def promStatus = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:9091", returnStdout: true).trim()
                    if (promStatus == "200") {
                        echo "✅ Monitor Node (Prometheus) доступний (HTTP 200)"
                    } else {
                        error "❌ Помилка: Prometheus повернув статус ${promStatus}"
                    }
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
        success {
            echo "🎉 Пайплайн повністю успішно пройдений!"
        }
        failure {
            echo "🚨 Пайплайн впав з помилкою. Перевірте логи вище."
        }
    }
}
