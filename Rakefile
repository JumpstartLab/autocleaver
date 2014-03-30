$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rake/testtask'
require 'autocleaver/caller'

Rake::TestTask.new do |t|
  t.libs << File.expand_path('../test', __FILE__)
  t.pattern = "test/*_test.rb"
end

# make a cleaver presentation from a markdown file
task :autocleave, :input_path do |_, input_path|
  Autocleaver::Caller.new(input_path[:input_path]).create_presentation
end

task default: :test
