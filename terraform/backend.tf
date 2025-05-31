terraform {
  backend "s3" {
    bucket     = "ilhamterrabucket"
    key        = "terraform/backend"
    region     = "us-east-1"
  }
}
