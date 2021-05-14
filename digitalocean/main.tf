terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.8.0"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_app" "hello-jamstack" {
  spec {
    name   = "hello-jamstack"
    region = "fra"

    static_site {

      name          = "hello-jamstack"
      environment_slug = "hugo"
      build_command = "rm -rf ./public; hugo --destination ./public"
      output_dir    = "/public"
      source_dir ="hello-hugo"

      github {
        branch         = "main"
        deploy_on_push = true
        repo           = "dirien/hello-jamstack"
      }

    }
  }
}