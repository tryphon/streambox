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

namespace :streambox do
  task :release do
    box_name = "streambox"

    build_server = "dev.tryphon.priv"
    dist_directory = "/var/lib/buildbot/dist"

    www_server = "www.tryphon.priv"
    download_dir = "/var/www/tryphon.eu/download"

    latest = YAML.load `ssh #{build_server} cat #{dist_directory}/#{box_name}/latest.yml`
    release_name = latest["name"]

    commit = (latest["commit"] or ENV['COMMIT'])
    raise "Select a git commit with COMMIT=... (see buildbot at http://dev.tryphon.priv:8010/builders/#{box_name}/)" unless commit

    puts "Publish last release : #{release_name} (commit #{commit})"

    sh "scp '#{build_server}:#{dist_directory}/#{box_name}/#{release_name}*' #{build_server}:#{dist_directory}/#{box_name}/latest.yml #{www_server}:#{download_dir}/#{box_name}"
    sh "git tag -a #{release_name} -m 'Release #{release_name}'"
    sh "git push --tags"
  end
end
