variable "data_path" {
  type        = string
  description = "Path to the data directory where required files data files are stored"
}

variable "tags" {
  type = map(string)
}
