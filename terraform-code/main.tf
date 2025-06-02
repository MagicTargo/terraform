module "flux_infra" {
  source = "../modules/common/flux_infra"

  flux_conf = local.flux_conf
}