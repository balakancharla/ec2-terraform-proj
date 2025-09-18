terraform {
  backend "s3" {
    bucket = "terraform-ec2-jenkins-state"   # Update with your bucket name
    key    = "ec2-instance/terraform.tfstate"
    region = "us-east-2"
  }
}
