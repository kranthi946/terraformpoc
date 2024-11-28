# Specify the provider (GCP, AWS, Azure)
provider "google" {
#credentials = "${file("credentials.json")}"
project = "ma-cicd"
region = "us-west1"
}
