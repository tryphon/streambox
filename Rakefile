Dir[File.join(File.dirname(__FILE__), "tasks", "*.rake")].each { |t| load t }

require 'rubygems'

require 'system_builder'
require 'system_builder/box_tasks'


SystemBuilder::BoxTasks.new(:streambox) do |box|
  box.disk_image do |image|
    image.size = 500.megabytes
  end
end

task :buildbot => "streambox:buildbot"
