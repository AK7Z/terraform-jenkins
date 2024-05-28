### Bucket for Jenkins setup files ###

resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "aws_s3_bucket" "jenkins_files" {
  bucket = "${var.project_name}-jenkins-files-${random_id.bucket_suffix.hex}"

  tags = {
    Name = "${var.project_name}-jenkins-files"
  }
}

### Upload files to S3 ###

resource "aws_s3_object" "config_general" {
  bucket = aws_s3_bucket.jenkins_files.bucket
  key    = "initJenkins.groovy"
  content = templatefile("${path.module}/files/initJenkins.tpl", {
    admin_username = var.jenkins_admin_username,
    admin_password = var.jenkins_admin_password
  })
  acl    = "private"
}

resource "aws_s3_object" "plugins" {
  bucket = aws_s3_bucket.jenkins_files.bucket
  key    = "plugins.txt"
  source = "${path.module}/files/plugins.txt"
  acl    = "private"
}