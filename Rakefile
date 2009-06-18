require(File.join(File.dirname(__FILE__), 'config', 'environment'))
require 'rake'
require 'rake/testtask'
require 'rake/runtest'

task :test do
  Rake.run_tests '**/*Test.rb'
end

task :cruise => [:test, :reinstall]