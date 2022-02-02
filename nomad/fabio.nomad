# ##############################################################################
# Use fabio as our reverse-proxy to services
#
# This allows us to access services running in nomad/consul from:
#     <url>:9999/<service>
#
# and not have to worry about where the service is deployed, and which port
# it is using.
#
# This is run as a 'system' so that it run on all the nomad servers. We can then
# reach any of the nomad servers IP at port 9999 to access our service
#
# Port 9999 is used by default for reverse-proxy, and port 9998 is the admin UI
#
# In the future, we may have only 'frontend' nomad servers which only run fabio
# ##############################################################################
job "fabio" {

  datacenters = ["dc1"]

  type = "system"

  group "fabio" {

    task "fabio" {

      driver = "exec"

      config {
        command = "fabio"
        args    = ["-proxy.strategy=rr"]
      }

      artifact {
        source      = "https://github.com/fabiolb/fabio/releases/download/v1.5.15/fabio-1.5.15-go1.15.5-linux_amd64"
        destination = "local/fabio"
        mode        = "file"
      }
    }
  }
}
