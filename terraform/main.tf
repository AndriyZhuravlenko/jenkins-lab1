terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Створюємо спільну мережу для лабораторної
resource "docker_network" "lab8_net" {
  name = "lab8_network"
}

# 1. App Node (Сервер додатка + node_exporter)
resource "docker_container" "app_node" {
  name  = "lab8-app-node"
  image = "ubuntu:22.04"
  
  # Залишаємо контейнер активним (імітація працюючої ВМ)
  command = ["tail", "-f", "/dev/null"]
  
  networks_advanced {
    name = docker_network.lab8_net.name
  }

  # Прокидаємо порти: 8084 на хості -> 80 в контейнері
  ports {
    internal = 80
    external = 8084
  }
  
  # Порт для node_exporter (збір метрик системи)
  ports {
    internal = 9100
    external = 9100
  }
}

# 2. Monitor Node (Сервер для Prometheus + Grafana)
resource "docker_container" "monitor_node" {
  name  = "lab8-monitor-node"
  image = "ubuntu:22.04"
  
  command = ["tail", "-f", "/dev/null"]
  
  networks_advanced {
    name = docker_network.lab8_net.name
  }

  # Порт для Prometheus
  ports {
    internal = 9090
    external = 9091
  }

  # Порт для Grafana
  ports {
    internal = 3000
    external = 3001
  }
}
