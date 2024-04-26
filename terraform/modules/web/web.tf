module "common" {
    source = "../common"
}

# S3 bucket for website.
resource "aws_s3_bucket" "www_domain" {
  bucket = "${module.common.domain_name}"
  tags = module.common.common_tags
}

resource "aws_s3_bucket_website_configuration" "www_domain_config" {
  bucket = aws_s3_bucket.www_domain.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "www_domain_bucket_acl" {
  bucket = aws_s3_bucket.www_domain.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "www_domain_bucket_policy" {
  bucket = "${aws_s3_bucket.www_domain.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${module.common.domain_name}/*"
    }
  ]
}
EOF
}

resource "aws_s3_object" "web_app" {
  for_each = fileset("${path.module}/web/dist/web", "*")
  bucket = aws_s3_bucket.www_domain.id
  key = each.value
  content_type = lookup(var.content_types, reverse(split(".", each.value))[0])
  source = "${path.module}/web/dist/web/${each.value}"
  etag = filemd5("${path.module}/web/dist/web/${each.value}")
}
