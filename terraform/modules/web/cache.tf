module "cloudfront_redirect_s3" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["example.com"]

  default_root_object = "index.html"

  origins = [
    {
      s3_bucket_domain_name = "${var.s3_bucket_name}.s3.amazonaws.com"
      s3_bucket_name       = var.s3_bucket_name
    }
  ]

  default_behavior = [
    {
      allowed_methods = ["GET", "HEAD"]
      cached_methods  = ["GET", "HEAD"]
      target_origin_id = "${var.s3_bucket_name}"
      viewer_protocol_policy = "redirect-to-https"
      min_ttl = 0
      default_ttl = 3600
      max_ttl = 86400
    }
  ]
}