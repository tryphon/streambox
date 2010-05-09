require 'rubygems'

require 'system_builder'
require 'system_builder/task'

load './local.rb' if File.exists?("./local.rb")

release_number = Time.now.strftime('%Y%m%d-%H%M')
release_name = "streambox-#{release_number}"

boot = SystemBuilder::DebianBoot.new("build/root")
boot.configurators << SystemBuilder::PuppetConfigurator.new(:release_name => release_name)

SystemBuilder::Task.new(:streambox) do
  SystemBuilder::DiskSquashfsImage.new("dist/disk").tap do |image|
    image.boot = boot
		image.size = 500.megabytes
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

task :dist do
  rm_rf "dist/upgrade"
  mkdir_p "dist/upgrade"
  cp "build/filesystem.squashfs", "dist/upgrade/filesystem-#{release_name}.squashfs"
  cp "build/root/vmlinuz", "dist/upgrade/vmlinuz-#{release_name}"
  cp "build/root/initrd.img", "dist/upgrade/initrd-#{release_name}.img"
  sh "tar -cf dist/#{release_name}.tar -C dist/upgrade ."

  checksum = %x{sha256sum dist/#{release_name}.tar}.split.first
  File.open("dist/latest.yml", "w") do |f|
    f.puts "name: #{release_name}"
    f.puts "url: http://download.tryphon.eu/streambox/updates/#{release_name}.tar"
    f.puts "checksum: #{checksum}"
    f.puts "status_updated_at: #{Time.now}"
    f.puts "description_url: http://www.tryphon.eu/blog/#{release_name}"
  end
end
