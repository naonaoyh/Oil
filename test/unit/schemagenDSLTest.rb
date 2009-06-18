# Copyright (c) 2007-2008 Orangery Technology Limited 
# You can redistribute it and/or modify it under the same terms as Ruby.
#
require 'test/unit'
require File.join(File.dirname(__FILE__),'..','..','lib','VPMSSchemaInterpreter')
require File.join(File.dirname(__FILE__),'..','..','lib','VPMSPackageSchemaInterpreter')
require File.join(File.dirname(__FILE__),'..','..','lib','VPMSProductSchemaInterpreter')
require File.join(File.dirname(__FILE__),'..','..','lib','VPMSComponentSchemaInterpreter')

class SchemaGenDSLTest < Test::Unit::TestCase
  TD_ROOT = File.join(File.dirname(__FILE__), '../fixtures')
  
  def test_initial_component_schema_gen
    open("#{TD_ROOT}/BuildingsCover.oil") {|f| @contents = f.read }
    dsl = @contents.to_s
    result = VPMSSchemaInterpreter.execute(dsl)
    #puts result
    assert_equal 1,1
  end
 
     #Todo: problem with personal accident cover at product level, so removed for now
     #has_one :PersonalAccidentCover
          
     #Todo: resolution problem with node which has multiple leaf nodes
     #so the multiplicity of these isn't reproduced e.g. sumInsured percent NESTS amount when the oil declares
     #just sumInsured - it needs to properly nest amount and percent inside suminsured
 
  def test_new_component_schema_gen
    open("#{TD_ROOT}/BuildingsCover.oil") {|f| @contents = f.read }
    dsl = @contents.to_s
    component_result = VPMSComponentSchemaInterpreter.execute(dsl)
    #puts component_result
    assert_equal 1,1
  end

  def test_product_schema_gen
    open("#{TD_ROOT}/product.oil") {|f| @contents = f.read }
    dsl = @contents.to_s
    product_result = VPMSProductSchemaInterpreter.execute(dsl)
    #File.open('pkg/VPMSSchema.xsd', 'w') {|f| f.write(product_result) }
    #puts product_result
    assert_equal 1,1
  end
  
  def test_package_schema_gen
    open("#{TD_ROOT}/package.oil") {|f| @contents = f.read }
    dsl = @contents.to_s
    package_result = VPMSPackageSchemaInterpreter.execute(dsl)
    #File.open('VPMSPackageSchema.xsd', 'w') {|f| f.write(package_result) }
    #puts package_result
    assert_equal 1,1
  end
  
end
