variable "name" {
    type = string
    default = ""
}

variable "role" {
    type = string
    default = ""
}

variable "subnet" {
    type = any
    default = []
}


variable "tg" {
    type = string
    default = ""
}

variable "ecsSG" {
    type = list
    default = []
}
