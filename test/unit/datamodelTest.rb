# Copyright (c) 2007-2008 Orangery Technology Limited
# You can redistribute it and/or modify it under the same terms as Ruby.
#
require 'test/unit'
require File.join(File.dirname(__FILE__),'..','..','lib','DataModelInterpreter')

class DataModelDSLTest < Test::Unit::TestCase
  TD_ROOT = File.join(File.dirname(__FILE__), '../fixtures')
  TD_EXP = File.join(File.dirname(__FILE__), '../expected')

  def test_tranform_data_model
    open("#{TD_ROOT}/DataModel.oil") {|f| @contents = f.read }
    dsl = @contents.to_s
    result = DataModelInterpreter.execute(dsl)

    #following lines were used to create the test files initially the program was working
    #result.each do |k,v|
      #File.open("#{TD_EXP}/#{k}DataModel.rb", 'w') {|f| f.write(v[0]) }
      #File.open("#{TD_EXP}/#{k}NodeNames.rb", 'w') {|f| f.write(v[1]) }
      #File.open("#{TD_EXP}/#{k}PropertyHash", 'w') {|f| f.write(v[2]) }
    #end

    open("#{TD_EXP}/FireTheftCoverageDataModel.rb") {|f| @dm = f.read }
    open("#{TD_EXP}/FireTheftCoverageNodeNames.rb") {|f| @nn = f.read }
    open("#{TD_EXP}/FireTheftCoveragePropertyHash") {|f| @ph = f.read }

    assert_equal result["FireTheftCoverage".to_sym][0],@dm
    assert_equal result["FireTheftCoverage".to_sym][1],@nn
    assert_equal result["FireTheftCoverage".to_sym][2],@ph
  end

end
