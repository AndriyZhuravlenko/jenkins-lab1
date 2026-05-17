FROM jenkins/jenkins:lts

# Вимикаємо майстер початкового налаштування
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Копіюємо список плагінів та встановлюємо їх
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

# Копіюємо скрипт автоматичного створення користувача admin/admin
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/
