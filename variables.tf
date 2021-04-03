variable "name" {
  type = string
  default = "malka"
  description = "The prefix used to name AWS resources, especially the ECS Cluster and Service"
}

variable "environment" {
  type = string
  default = "production"
  description = "The environment tag. It is used as suffix for all created AWS resources."
}

variable "configuration" {
  type = list(object({
    topic_name = string,
    topic_number_of_consumers = number,
    consumer_configuration = map(string),
    target_functions = list(string)
  }))

  description = "Defines how the Malka consumer will behave internally. Each function target available on each Malka configuration entry implies a new consumer group being internally deployed inside the Malka consumer. In practice, if you have two configurations with two target functions each we will end up with active 4 consumer groups."
}

variable "vpc_id" {
  type = string
  description = "VPC ID to be used by ECS"
}

variable "subnet_ids" {
  type = list(string)
  description = "Subnet IDs for the Malka's ECS tasks"
}

variable "kafka_brokers" {
  type = list(string)
  description = "A list of strings containing a Kafka Broker URL. It compatible with terraform 'bootstrap_brokers' variable, accepting entries which content is a comma-separated list of URLs."
}

variable "kafka_security_protocol" {
  type = string
  description = "Protocol used to communicate with brokers. Valid values: plaintext, ssl"
  default = "ssl"
}

variable "cpu" {
  type = number
  description = "CPU capacity of the nodes running tasks"
  default = 1024
}

variable "memory" {
  type = number
  description = "Memory capacity of the nodes running tasks"
  default = 2048
}

variable "desired_count" {
  type = number
  description = "Desired number of nodes running tasks"
  default = 1
}

variable "min_capacity" {
  type = number
  description = "Minimum number of nodes running tasks"
  default = 1
}

variable "max_capacity" {
  type = number
  description = "Maximum number of nodes running tasks"
  default = 1
}