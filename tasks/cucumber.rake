begin
  require 'cucumber/rake/task'

  namespace :cucumber do
    Cucumber::Rake::Task.new(:ok, 'Run features that should pass') do |t|
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'default'
    end

    Cucumber::Rake::Task.new(:wip, 'Run features that are being worked on') do |t|
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'wip'
    end

    Cucumber::Rake::Task.new(:rerun, 'Record failing features and run only them if any exist') do |t|
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'rerun'
    end

    desc 'Run all features'
    task :all => [:ok, :wip]
  end
  desc 'Alias for cucumber:ok'
  task :cucumber => 'cucumber:ok'

  task :default => :cucumber

  task :features => :cucumber do
    STDERR.puts "*** The 'features' task is deprecated. See rake -T cucumber ***"
  end
rescue LoadError
  desc 'cucumber rake task not available (cucumber not installed)'
  task :cucumber do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
