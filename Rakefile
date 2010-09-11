require 'rubygems'

require 'system_builder'
require 'system_builder/task'

["#{ENV['HOME']}/.system_builder.rc", "./local.rb"].each do |conf|
  load conf if File.exists?(conf)
end

Dir['tasks/**/*.rake'].each { |t| load t }

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

SystemBuilder::Task.new(:"streambox-demo") do
  SystemBuilder::IsoSquashfsImage.new("dist/iso").tap do |image|
    image.boot = boot
  end
end

task :setup => "streambox:setup"

def create_latest_file(latest_file, release_name, release_number)
  checksum = %x{sha256sum dist/upgrade.tar}.split.first
  File.open(latest_file, "w") do |f|
    f.puts "name: #{release_name}"
    f.puts "url: http://download.tryphon.eu/streambox/streambox-#{release_number}.tar"
    f.puts "checksum: #{checksum}"
    f.puts "status_updated_at: #{Time.now}"
    f.puts "description_url: http://www.tryphon.eu/release/#{release_name}"
  end
end

namespace :buildbot do
  task :dist do
    mkdir_p target_directory = "#{ENV['HOME']}/dist/streambox"
    cp "dist/disk", "#{target_directory}/streambox-#{release_number}.disk"
    cp "dist/iso", "#{target_directory}/streambox-#{release_number}.iso"
    cp "dist/upgrade.tar", "#{target_directory}/streambox-#{release_number}.tar"
    create_latest_file "#{target_directory}/latest.yml", release_name, release_number
  end
end

task :buildbot => [:clean, "dist:all", "buildbot:dist"] do
  # clean in dependencies is executed only once
  Rake::Task["clean"].invoke
end

namespace :dist do
  desc "Create all distribuable artifacts"
  task :all => [:disk, :iso, :upgrade]

  desc "Create disk image"
  task :disk => "streambox:dist"

  desc "Create iso image"
  task :iso => "streambox-demo:dist"

  desc "Create upgrade files"
  task :upgrade do
    rm_rf "dist/upgrade"
    mkdir_p "dist/upgrade"
    ln_s File.expand_path("build/filesystem.squashfs"), "dist/upgrade/filesystem-#{release_name}.squashfs"
    ln_s File.expand_path("build/root/vmlinuz"), "dist/upgrade/vmlinuz-#{release_name}"
    ln_s File.expand_path("build/root/initrd.img"), "dist/upgrade/initrd-#{release_name}.img"
    sh "tar -cf dist/upgrade.tar --dereference -C dist/upgrade ."
  end
end
