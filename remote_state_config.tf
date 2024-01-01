terraform{
    backend "s3" {
        bucket = "tf-state-bucket-01"
        key = "finance/terraform.tfstate"
        region = "us-west-01"
        dynamodb_table = "state-locking"
    }
}
