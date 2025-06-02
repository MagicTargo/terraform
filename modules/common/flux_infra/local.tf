locals {
  flux_conf                = var.flux_conf
  ordered_flux_conf_keys   = var.ordered_flux_conf_keys

  indexed_flux_conf = {
    for idx, key in local.ordered_flux_conf_keys :
    key => {
      index  = idx
      config = local.flux_conf[key]
    }
  }
}
