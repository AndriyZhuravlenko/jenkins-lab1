terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.0"
    }
  }
}

provider "docker" {}

resource "docker_container" "web_server" {
  name  = "jenkins-managed-node"
  image = "ubuntu:22.04"
  command = ["tail", "-f", "/dev/null"]
  ports {
    internal = 80
    external = 8083
  }
}

# Виводимо ім'я контейнера, щоб Ansible міг підключитися через docker-конектор
output "server_ip" {
  value = docker_container.web_server.name
}
