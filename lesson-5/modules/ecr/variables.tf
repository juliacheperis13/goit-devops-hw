variable "ecr_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "scan_on_push" {
  description = "Enable automatic image scan on push"
  type        = bool
  default     = true
}
