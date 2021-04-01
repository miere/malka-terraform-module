variable "name" {
  type = string
  default = "malka"
}

variable "region" {}

variable "environment" {
  type = string
  default = "production"
}

variable "configuration" {
  type = list(object({
    topic_name = string,
    topic_number_of_consumers = number,
    consumer_configuration = map(string),
    target_functions = list(string)
  }))
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "kafka_brokers" {
  type = list(string)
}