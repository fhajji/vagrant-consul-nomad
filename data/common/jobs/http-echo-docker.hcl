# Start a simple http-echo Nomad job
# 
# This Nomad job places a hashicorp/http-echo test container which
# listens on a pre-defined port and echoes a predefined string to
# anyone who connects to that port.
# 
# How to use:
# master0:/vagrant_data/jobs$ nomad job plan http-echo-docker.hcl
# master0:/vagrant_data/jobs$ nomad job run -check-index SOMEINDEX \
#                                   http-echo-docker.hcl
# 
# See the main README.md for further instructions.
# 
# Inspired and modified from:
#   https://learn.hashicorp.com/tutorials/nomad/jobs-submit

job "docs" {
  datacenters = ["dc1"]

  type = "service"

  # All tasks with a group will be co-located on the same node
  group "example" {
    count = 3

    network {
      # mode = "bridge"

      port "http" {
        static = 5678
        # to     = 5678
      }
    }

    # The service block tells Nomad to register this service
    # with Consul for service discovery and monitoring
    service {
      name = "http-echo-service"

      # Consul should monitor the service on the port labelled
      # "http". If could be either dynamically set by Nomad,
      # or statically configured below.
      port = "http"

      check {
        type = "http"
        path = "/health"
        interval = "10s"
        timeout = "2s"
      }

      # This is for Consul Connect
      # connect {
      #   sidecar_service {}
      # }
    }

    # A task is an individual unit of work. Here, it is a running
    # Docker container, listening on a particular port.
    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/http-echo"

        args = [
          "-listen",
          ":5678",
          "-text",
          "hello localhost world",
        ]
      }

      # Pass environment variables to the container
      env {
        MY_VAR1 = "some value to pass to the container"
        MY_VAR2 = "another value to pass to the container"
      }

      # Resources required to run the task
      resources {
        cpu    = 300 # MHz
        memory = 128  # MB
      }
    }
  }
}
