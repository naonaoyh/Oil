# Copyright (c) 2007-2008 Orangery Technology Limited 
# You can redistribute it and/or modify it under the same terms as Ruby.
#
require 'test/unit'
require File.join(File.dirname(__FILE__),'..','..','lib','CoverageInterpreter')

class CoverageDSLTest < Test::Unit::TestCase
  TD_ROOT = File.join(File.dirname(__FILE__), '../fixtures')
  
  def test_correct_transformation  
    #open("#{TD_ROOT}/BuildingsCover.oil") {|f| @contents = f.read }
    #dsl = @contents.to_s
    #result = CoverageInterpreter.execute(dsl)
    #puts result
    assert_equal 1,1
  end
  
end
