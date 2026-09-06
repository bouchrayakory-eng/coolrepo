variable "aws_region" {
  default = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name for hosting website files"
  default     = "coolrepo-portfolio-site-bouchraya-2026"
}

variable "github_org_or_user" {
  description = "Your GitHub username or organization name"
  type        = string
}

variable "github_repo" {
  description = "Your GitHub repository name"
  type        = string
  default     = "coolrepo"
}
