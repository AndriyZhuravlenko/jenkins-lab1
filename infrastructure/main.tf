terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.0"
    }
  }
}

provider "docker" {}

# Перший сервер
resource "docker_container" "server_1" {
  name  = "node_server_1"
  image = "ubuntu:22.04"
  command = ["tail", "-f", "/dev/null"]
  ports {
    internal = 80
    external = 8081
  }
}

# Другий сервер
resource "docker_container" "server_2" {
  name  = "node_server_2"
  image = "ubuntu:22.04"
  command = ["tail", "-f", "/dev/null"]
  ports {
    internal = 80
    external = 8082
  }
}
