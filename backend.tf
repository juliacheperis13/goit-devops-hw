# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-bucket-julia-10110"
#     key            = "lesson-5/terraform.tfstate"  
#     region         = "us-east-1"                   
#     dynamodb_table = "terraform-locks"              
#     encrypt        = true                          
#   }
# }
