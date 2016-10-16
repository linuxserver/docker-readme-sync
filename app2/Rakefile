require 'rspec/core/rake_task'

Dir.glob(File.expand_path('../tasks', __FILE__) + '/**/*.rake').each {|file| import file }

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec]
