// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("account.json")}"
  project     = "strange-flame-188720"
  region      = "europe-west1"
}
