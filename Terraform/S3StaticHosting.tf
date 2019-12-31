resource "aws_s3_bucket" "static_hosting" {
  bucket = "www.test-overmind.com"
  website {
    index_document = "index.html"
  }
}
resource "aws_s3_bucket_policy" "site" {
  bucket = "${aws_s3_bucket.static_hosting.id}"
  policy = "${data.aws_iam_policy_document.site_public_access.json}"
}

data "aws_iam_policy_document" "site_public_access" {
  statement {
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static_hosting.arn}/*"]

    principals {
      type = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    actions = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.static_hosting.arn}"]

    principals {
      type = "AWS"
      identifiers = ["*"]
    }
  }
}
resource "aws_s3_bucket_object" "object" {
  bucket = "${aws_s3_bucket.static_hosting.id}"
  key    = "index.html"
  source = "../index.html"
  content_type = "text/html"
  # etag = "${md5(file("../index.html"))}"
  etag = "${filemd5("../index.html")}"
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  #etag = "${filemd5("path/to/file")}"
}