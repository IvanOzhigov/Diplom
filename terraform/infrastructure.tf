terraform {
  required_version = "= 1.8.2"
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "    " # OAuth-токен яндекса
  cloud_id  = "    "
  folder_id = "    b"
}


# ВМ для Веб сервера 1


resource "yandex_compute_instance" "vm-webserver1" {
  name                      = "webserver1"
  hostname                  = "webserver1"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true #для обновления конфигурации требующих остановку ВМ
  zone                      = "ru-central1-a"

  resources {
    core_fraction = 20 # Гарантированная доля vCPU
    cores         = 2  # vCPU
    memory        = 2  # RAM
  }

  boot_disk {
    initialize_params {
      image_id = "fd8tvc3529h2cpjvpkr5"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_webserver1.id
    security_group_ids = [yandex_vpc_security_group.general.id]
    ip_address         = "192.168.15.10"
  }
  metadata = {
    user-data = "${file("/home/ivanozhigov/github/diplom/terraform/key/meta.yml")}"
  }
}

# ВМ для Веб сервера 2

resource "yandex_compute_instance" "vm-webserver2" {
  name                      = "webserver2"
  hostname                  = "webserver2"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true #для обновления конфигурации требующих остановку ВМ
  zone                      = "ru-central1-b"

  resources {
    core_fraction = 20 # Гарантированная доля vCPU
    cores         = 2  # vCPU
    memory        = 2  # RAM
  }

  boot_disk {
    initialize_params {
      image_id = "fd8tvc3529h2cpjvpkr5"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_webserver2.id
    security_group_ids = [yandex_vpc_security_group.general.id]
    ip_address         = "192.168.16.10"
  }
  metadata = {
    user-data = "${file("/home/ivanozhigov/github/diplom/terraform/key/meta.yml")}"
  }
}

#ВМ для bastion сервера

resource "yandex_compute_instance" "bastion-host" {
  name                      = "bastion"
  hostname                  = "bastion"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true
  zone                      = "ru-central1-d"

  resources {
    core_fraction = 20 # Гарантированная доля vCPU
    cores         = 2  # vCPU
    memory        = 2  # RAM
  }

  boot_disk {
    initialize_params {
      image_id = "fd8tvc3529h2cpjvpkr5"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_general.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.general.id, yandex_vpc_security_group.bastion_ssh.id]
    ip_address         = "192.168.18.10"
  }
  metadata = {
    user-data = "${file("/home/ivanozhigov/github/diplom/terraform/key/meta.yml")}"
  }
}

# ВМ для Zabbix

resource "yandex_compute_instance" "vm-zabbix" {
  name                      = "zabbix"
  hostname                  = "zabbix"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true #для обновления конфигурации требующих остановку ВМ
  zone                      = "ru-central1-d"

  resources {
    core_fraction = 20 # Гарантированная доля vCPU
    cores         = 2  # vCPU
    memory        = 2  # RAM
  }

  boot_disk {
    initialize_params {
      image_id = "fd8tvc3529h2cpjvpkr5"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_general.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.zabbix.id, yandex_vpc_security_group.general.id]
    ip_address         = "192.168.18.11"
  }
  metadata = {
    user-data = "${file("/home/ivanozhigov/github/diplom/terraform/key/meta.yml")}"
  }
}

# ВМ для Elastic

resource "yandex_compute_instance" "vm-elastic" {
  name                      = "elastic"
  hostname                  = "elastic"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true #для обновления конфигурации требующих остановку ВМ
  zone                      = "ru-central1-d"

  resources {
    core_fraction = 20 # Гарантированная доля vCPU
    cores         = 2  # vCPU
    memory        = 2  # RAM
  }

  boot_disk {
    initialize_params {
      image_id = "fd8tvc3529h2cpjvpkr5"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_bastion.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.general.id]
    ip_address         = "192.168.17.10"
  }
  metadata = {
    user-data = "${file("/home/ivanozhigov/github/diplom/terraform/key/meta.yml")}"
  }
}

#ВМ для Kibana

resource "yandex_compute_instance" "vm-kibana" {
  name                      = "kibana"
  hostname                  = "kibana"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true #для обновления конфигурации требующих остановку ВМ
  zone                      = "ru-central1-d"

  resources {
    core_fraction = 20 # Гарантированная доля vCPU
    cores         = 2  # vCPU
    memory        = 2  # RAM
  }

  boot_disk {
    initialize_params {
      image_id = "fd8tvc3529h2cpjvpkr5"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_general.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.ek.id, yandex_vpc_security_group.general.id]
    ip_address         = "192.168.18.12"
  }
  metadata = {
    user-data = "${file("/home/ivanozhigov/github/diplom/terraform/key/meta.yml")}"
  }
}

# Создание общей сети

resource "yandex_vpc_network" "vm_network" {
  name = "network"
}

resource "yandex_vpc_route_table" "nat" {
  network_id = yandex_vpc_network.vm_network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.18.10"
  }
}


# Создание подсети для Веб сервера 1

resource "yandex_vpc_subnet" "subnet_webserver1" {
  name           = "sub_webserver1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vm_network.id
  v4_cidr_blocks = ["192.168.15.0/24"]
  route_table_id = yandex_vpc_route_table.nat.id
}

# Создание подсети для Веб сервера 2

resource "yandex_vpc_subnet" "subnet_webserver2" {
  name           = "sub_webserver2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vm_network.id
  v4_cidr_blocks = ["192.168.16.0/24"]
  route_table_id = yandex_vpc_route_table.nat.id
}

# Создание публичной подсети

resource "yandex_vpc_subnet" "subnet_general" {
  name           = "sub_general"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.vm_network.id
  v4_cidr_blocks = ["192.168.18.0/24"]
}

# Создание приватной подсети

resource "yandex_vpc_subnet" "subnet_bastion" {
  name           = "sub_bastion"
  zone           = "ru-central1-d"
  v4_cidr_blocks = ["192.168.17.0/24"]
  network_id     = yandex_vpc_network.vm_network.id
  route_table_id = yandex_vpc_route_table.nat.id
}


#Создание security_group без ограничения внутри подсетей.

resource "yandex_vpc_security_group" "general" {
  name       = "general"
  network_id = yandex_vpc_network.vm_network.id
  ingress {
    protocol       = "Any"
    v4_cidr_blocks = ["192.168.0.0/16"]
  }
  egress {
    protocol       = "Any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#Создание security_group для bastion host подключение по ssh

resource "yandex_vpc_security_group" "bastion_ssh" {
  name       = "bastion"
  network_id = yandex_vpc_network.vm_network.id
  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#Создание security_group для zabbix

resource "yandex_vpc_security_group" "zabbix" {
  name       = "zabbix"
  network_id = yandex_vpc_network.vm_network.id
  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }
  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 10051
  }
  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#Создание security_group для kibana

resource "yandex_vpc_security_group" "ek" {
  name       = "ek"
  network_id = yandex_vpc_network.vm_network.id
  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 5601
  }
  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#Создание security_group для балансировщика

resource "yandex_vpc_security_group" "balancer" {
  name       = "balancer"
  network_id = yandex_vpc_network.vm_network.id
  ingress {
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    predefined_target = "healthchecks"
  }
  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }
  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


#Создание целевой группы для Веб серверов

resource "yandex_alb_target_group" "my-target-group" {
  name = "my-target-group"
  target {
    subnet_id  = yandex_vpc_subnet.subnet_webserver1.id
    ip_address = "192.168.15.10"
  }
  target {
    subnet_id  = yandex_vpc_subnet.subnet_webserver2.id
    ip_address = "192.168.16.10"
  }
}

#Создание группы бекендов

resource "yandex_alb_backend_group" "my-backend-group" {
  name = "my-backend-group"
  http_backend {
    name             = "http"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.my-target-group.id]
    load_balancing_config {
      panic_threshold = 90
    }
    healthcheck {
      healthcheck_port    = 80 # порт 80
      timeout             = "10s"
      interval            = "2s"
      healthy_threshold   = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path = "/" #  путь на корень
      }
    }
  }
}


#Создание роутера

resource "yandex_alb_http_router" "my-tf-router" {
  name = "my-tf-router"
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name           = "my-virtual-host"
  http_router_id = yandex_alb_http_router.my-tf-router.id
  route {
    name = "route1"
    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }
      http_route_action {
        backend_group_id = yandex_alb_backend_group.my-backend-group.id
        timeout          = "60s"
      }
    }
  }
}

#Создание таблицы маршрутизации

resource "yandex_vpc_route_table" "inner-to-nat" {
  network_id = yandex_vpc_network.vm_network.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.18.10"
  }
}


#Создание балансировщика

resource "yandex_alb_load_balancer" "my-balancer" {
  name               = "my-balancer"
  network_id         = yandex_vpc_network.vm_network.id
  security_group_ids = [yandex_vpc_security_group.general.id, yandex_vpc_security_group.balancer.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-d"
      subnet_id = yandex_vpc_subnet.subnet_bastion.id
    }
  }

  listener {
    name = "listen"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.my-tf-router.id
      }
    }
  }
}

#Создание snapshot дисков ВМ

resource "yandex_compute_snapshot_schedule" "snapshot" {
  name = "snapshot"

  schedule_policy {
    expression = "0 1 * * *"
  }

  retention_period = "168h"

  snapshot_spec {
    description = "everyday-snapshot"
  }
  disk_ids = [yandex_compute_instance.vm-webserver1.boot_disk.0.disk_id, yandex_compute_instance.vm-webserver2.boot_disk.0.disk_id, yandex_compute_instance.bastion-host.boot_disk.0.disk_id, yandex_compute_instance.vm-zabbix.boot_disk.0.disk_id, yandex_compute_instance.vm-elastic.boot_disk.0.disk_id, yandex_compute_instance.vm-kibana.boot_disk.0.disk_id]
}
