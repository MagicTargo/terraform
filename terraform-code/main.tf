module "flux_infra" {
  source = "../modules/common/flux_infra"

  team_flux_conf = local.team_flux_conf
}

output "team_flux_kustomizations_debug" {
  description = "Debug info for all team kustomizations"
  value       = module.flux_infra.fetch_kustomization_debug
}