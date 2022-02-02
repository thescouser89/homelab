# ##############################################################################
# Redis job
# ##############################################################################
job "redis" {
    datacenters = ["dc1"]
    type        = "service"

    group "cache" {

        service {
            name = "redis"
            port = "redis"
            tags = ["urlprefix-127.0.0.1:6379"]
            # Need to add check for consul to work
            check {
                name     = "alive"
                type     = "tcp"
                interval = "10s"
                timeout  = "2s"
            }
        }

        network {
            port "redis" {
                to = 6379
            }
        }

        task "redis" {
            driver = "podman"
            config {
                image = "docker://redis"
                ports = ["redis"]
            }
        }
    }
}
