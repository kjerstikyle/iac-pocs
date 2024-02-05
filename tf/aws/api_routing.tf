// Define api paths and options

// Create/list entities
module "resource_entities" {
  source                         = "./modules/api_resource"
  path                           = "entities"
  api_gateway_parent_resource_id = module.api_gw.gw_root_resource_id
  api_gateway_id                 = module.api_gw.gw_id
}

module "api_options-entities" {
  source         = "./modules/api_options_method"
  api_gateway_id = module.api_gw.gw_id
  resource_id    = module.resource_list.resource_id
  allow_methods  = "GET,POST,OPTIONS"
}

// Get/update/delete entity

module "resource_entities_id" {
  source                         = "./modules/api_resource"
  path                           = "{id}"
  api_gateway_parent_resource_id = module.api_gw.gw_root_resource_id
  api_gateway_id                 = module.api_gw.gw_id
}

module "api_options-entities_id" {
  source         = "./modules/api_options_method"
  api_gateway_id = module.api_gw.gw_id
  resource_id    = module.resource_entities_id.resource_id
  allow_methods  = "GET,PUT,DELETE,OPTIONS"
}
