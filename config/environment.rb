require 'yaml'
path = "config/environment.yml"
APP_CONFIG = YAML.load_file(path)
COVERAGE_DSL_ROOT = "#{File.dirname(__FILE__)}/../test/fixtures"
COVERAGE_DEF_ROOT = "#{File.dirname(__FILE__)}/../test/fixtures"
ENTITY_DSL_ROOT = "#{File.dirname(__FILE__)}/../test/fixtures"
ENTITY_DEF_ROOT = "#{File.dirname(__FILE__)}/../test/fixtures"
OIL_DSL_ROOT = File.join(File.dirname(__FILE__), '../../RailsApp/public/git/products/*')
OIL_HASH_ROOT = File.join(File.dirname(__FILE__), '../../RailsApp/public/git/libraries')
LIBRARY_ROOT = File.join(File.dirname(__FILE__), '../../RailsApp/public/git/libraries')
