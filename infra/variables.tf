variable "location" {
  type        = string
  description = "Azure region for the DownDetector resources"
}


variable "acr_location" {
  type        = string
  description = "Azure region for Container Registry"
}

variable "container_app_location" {
  type        = string
  description = "Azure region for Container Apps"
}