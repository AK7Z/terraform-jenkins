variable "ami_id" {
    type = string
    default = "ami-0843a4d6dc2130849"
}

variable "region" {
    type = string
    default = "eu-west-1"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "project_name" {
    type = string
    
}

variable "project_owner" {
    type = string

}

variable "ami_key_pair_name" {
    type = string
    
}

variable "jenkins_tf_state_bucket_arn" {
    type = string
}

variable "jenkins_admin_username" {
    type = string
    description = "The Jenkins Admin username, set in your .tfvars"
}

variable "jenkins_admin_password" {
    type = string
    description = "The Jenkins Admin password, set in your .tfvars"
    sensitive = true
}