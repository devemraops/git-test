terraform {
backend "s3" {
    bucket = "work-cluster-s3"
    region = "us-east-2"
    profile = "silver"
    # dynamodb_table = "create table "

    encrypted = true
}
}