variable "ghcr_pat" {
  description = "GitHub Container Registry Personal Access Token"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "EC2 Key pair name"
  type        = string
}