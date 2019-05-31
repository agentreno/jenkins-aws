# Uses ~/.aws/credentials, default profile
provider "aws" {
    region = "${var.region}"
    profile = "${var.profile}"
}
