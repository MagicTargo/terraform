variable "flux_conf" {
  description = "Map of additional Flux configurations"
  type        = map(any)
}

variable "flux_depends_on" {
  type = map(list(string))
}