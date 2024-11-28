# Specify the provider (GCP, AWS, Azure)
provider "google" {
credentials = "${file("credentials.json")}"
project = "carbide-trees-336004"
region = "us-west1"
}