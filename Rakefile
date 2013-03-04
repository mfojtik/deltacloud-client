require 'rubygems'
require 'erb'
require 'pry' rescue LoadError

namespace :collection do
  desc 'Generate model/methods files for collection.'
  task :generate, :name do |t, args|
    require_relative './lib/deltacloud/core_ext'
    model_tpl = ERB.new(File.read('support/model_template.erb'))
    methods_tpl = ERB.new(File.read('support/methods_template.erb'))
    name = args[:name]
    model_file = "lib/deltacloud/client/models/#{name}.rb"
    methods_file = "lib/deltacloud/client/methods/#{name}.rb"
    puts model_body = model_tpl.result(binding)
    print "Save model to '#{model_file}'? [Y/n]"
    answer = $stdin.gets.chomp
    if answer.empty? or answer == 'Y'
      File.open(model_file, 'w') { |f|
        f.write(model_body)
      }
      File.open('lib/deltacloud/client/models.rb', 'a') { |f|
        f.puts "require_relative './models/#{name}'"
      }
    end
    puts methods_body = methods_tpl.result(binding)
    print "Save methods to '#{methods_file}'? [Y/n]"
    answer = $stdin.gets.chomp
    if answer.empty? or answer == 'Y'
      File.open(methods_file, 'w') { |f|
        f.write(methods_body)
      }
      File.open('lib/deltacloud/client/methods.rb', 'a') { |f|
        f.puts "require_relative './methods/#{name}'"
      }
    end
    puts
    puts "Don't forget to add this line to 'lib/deltacloud/client/connection.rb':"
    puts
    puts "include Deltacloud::Client::Methods::#{name.to_s.camelize}"
    puts
  end
end

desc "Open console with client connected to #{ENV['API_URL'] || 'localhost:3002/api'}"
task :console do
  unless binding.respond_to? :pry
    puts 'To open a console, you need to have "pry" installed (gem install pry)'
    exit(1)
  end
  require_relative './lib/deltacloud/client'
  client = Deltacloud::Client(
    ENV['API_URL'] || 'http://localhost:3002/api',
    ENV['API_USER'] || 'mockuser',
    ENV['API_PASSWORD'] || 'mockpassword'
  )
  binding.pry
end
