$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_admin_manage_states/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_admin_manage_states"
  s.version     = RailsAdminManageStates::VERSION
  s.authors     = ["Danik"]
  s.email       = ["31.10.93@bk.ru"]
  s.homepage    = "https://github.com/SuperMasterBlasterLaser/rails_admin_manage_states"
  s.summary     = "Simple addon to use state_machines gem in rails_admin."
  s.description = "Simple addon to use state_machines gem in rails_admin."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.0"
end
