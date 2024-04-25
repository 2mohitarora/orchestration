job "pytechco-redis" {
  type = "service"

  group "ptc-redis" {
    count = 1
    network {
      port "redis" {
        to = 6379
      }
    }

    service {
      name     = "redis-svc"
      port     = "redis"
      tags = ["redis"]
      provider = "consul"
      check {
        name     = "redis_probe"
        type     = "tcp"
        interval = "10s"
        timeout  = "1s"
      }
    }

    task "redis-task" {
      driver = "docker"

      config {
        image = "redis:7.0.7-alpine"
        ports = ["redis"]
      }
    }
  }
}