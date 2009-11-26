# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{iab-Oil}
  s.version = "0.1.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gary Mawdsley"]
  s.date = %q{2009-03-31}
  s.description = %q{Oil is a RAILS based mini language for Financial Applications}
  s.email = %q{garymawdsley@gmail.com}
  s.files = ["lib/CollesceProductInterpreter.rb","lib/RailsProcessInterpreter.rb","lib/CoverageInterpreter2.rb","lib/RatingEngineResolver.rb","lib/CoverageInterpreter.rb","lib/SiteProcessInterpreter.rb","lib/DataModelInterpreter.rb","lib/VPMSComponentSchemaInterpreter.rb","lib/DSLContext.rb","lib/VPMSPackageSchemaInterpreter.rb","lib/Element.rb","lib/VPMSProductSchemaInterpreter.rb","lib/LayoutInterpreter.rb","lib/VPMSSchemaInterpreter.rb","lib/ProductInterpreter.rb","lib/ProductInterpreter2.rb","lib/xslt/VPMSPackageSchemaInterpreter.xsl","lib/xslt/VPMSSchemaInterpreter.xsl"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/iab/Oil}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{Oil}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Oil is a RAILS based mini language for Financial Applications}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mime-types>, [">= 1.15"])
      s.add_runtime_dependency(%q<diff-lcs>, [">= 1.1.2"])
    else
      s.add_dependency(%q<mime-types>, [">= 1.15"])
      s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
    end
  else
    s.add_dependency(%q<mime-types>, [">= 1.15"])
    s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
  end
end
