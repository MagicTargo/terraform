module "cluster_infra" {
  source = "git::https://github.com/MagicTargo/terraform.git//modules/common/flux_infra?ref=main"
  
  flux_conf= local.flux_conf
}