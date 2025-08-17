resource "aws_s3_bucket" "vindot_tenants" {
  bucket = "vindot-llc-tenants"

  tags = {
    Property = "5069 Pernod"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.vindot_tenants.bucket
  key    = "tenants.yml"
  source = "./renters.yml"

}