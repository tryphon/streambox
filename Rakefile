require 'rubygems'

require 'system_builder'
require 'system_builder/box_tasks'

 Dir['tasks/**/*.rake'].each { |t| load t }

SystemBuilder::BoxTasks.new(:streambox) do |box|
  box.boot do |boot|
    boot.version = :squeeze
  end
end

desc "Run continuous integration tasks (spec, ...)"
task :ci => "streambox:buildbot"
