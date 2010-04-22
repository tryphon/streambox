require 'rubygems'

require 'system_builder'
require 'system_builder/task'

load './local.rb' if File.exists?("./local.rb")

boot = SystemBuilder::DebianBoot.new("build/root")
boot.configurators << SystemBuilder::PuppetConfigurator.new

SystemBuilder::Task.new(:streambox) do
  SystemBuilder::DiskSquashfsImage.new("dist/disk").tap do |image|
    image.boot = boot
		image.size = 200.megabytes
  end
end

# SystemBuilder::Task.new(:"streambox-demo") do
#   SystemBuilder::IsoSquashfsImage.new("dist/iso").tap do |image|
#     image.boot = boot
#   end
# end

desc "Setup your environment to build a streambox image"
task :setup => "streambox:setup" do
  if ENV['WORKING_DIR']
    %w{build dist}.each do |subdir|
      working_subdir = File.join ENV['WORKING_DIR'], subdir
      puts "* create and link #{working_subdir}"
      mkdir_p working_subdir
      ln_sf working_subdir, subdir
    end
  end
end

task :clean do
  sh "sudo sh -c \"fuser $PWD/build/root || rm -r build/root\"" if File.exists?("build/root")
  rm_rf "dist"
  mkdir_p "dist"
end

namespace :buildbot do
  task :dist do
    mkdir_p target_directory = "#{ENV['HOME']}/dist/streambox"
    cp "dist/disk", "#{target_directory}/disk-#{Time.now.strftime("%Y%m%d-%H%M")}"
  end
end

task :buildbot => [:clean, "streambox:dist", "buildbot:dist"]
