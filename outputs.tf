output "github_role_arn" {
  description = "ARN of the IAM role for GitHub Actions OIDC"
  value       = aws_iam_role.github_actions.arn
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the website"
  value       = aws_s3_bucket.portfolio.id
}

output "cloudfront_url" {
  description = "URL of the CloudFront distribution"
  value       = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}
