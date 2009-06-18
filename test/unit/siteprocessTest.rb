# Copyright (c) 2007-2008 Orangery Technology Limited
# You can redistribute it and/or modify it under the same terms as Ruby.
#
require 'test/unit'
require File.join(File.dirname(__FILE__),'..','..','lib','SiteProcessInterpreter')

class SiteProcessDSLTest < Test::Unit::TestCase
  TD_ROOT = File.join(File.dirname(__FILE__), '../fixtures')
  TD_EXP = File.join(File.dirname(__FILE__), '../expected')

  def test_tranform_site_process
    open("#{TD_ROOT}/SiteProcesses.oil") {|f| @contents = f.read }
    dsl = @contents.to_s
    result = SiteProcessInterpreter.execute(dsl)
    #puts "#{result[0]}\n-----\n"
    #puts "#{result[1]}\n-----\n"
    #puts "#{result[2].length}\n-----\n"

    assert_equal "#{result[1]}","PersonalMotor"
  end

end