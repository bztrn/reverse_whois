class Sinatrize

  def self.generate
    new.generate
  end

  def initialize
    @files = []
  end

  def generate
    dir "config"
    dir "views"
    dir "public"

    file "env.rb", <<HERE.gsub('^\s+', '')
      require 'bundler/setup'
      Bundler.require :default
    HERE

    file "Gemfile", <<HERE.gsub('^\s+', '')
      source "http://rubygems.org"

      gem "sinatra", github: "sinatra/sinatra"

      gem 'sucker_punch', '~> 1.0'

    HERE

    file "app.rb", <<HERE.gsub('^\s+', '')
      require_relative "../config/env"

      class ReverseWhois
        get "/" do
          haml :index
        end
      end

    HERE

    file "config.ru", <<HERE.gsub('^\s+', '')
      require "./reverse_whois"

      run ReverseWhois

    HERE

    file "Readme.md", <<HERE.gsub('^\s+', '')
      # App.rb

      generated with makevoid/sinatrize_mini.rb
    HERE

    file "views/index.haml", <<HERE.gsub('^\s+', '')
      %html
        %head
          %title Reverse whois lookup

        %body
          Reverse whois lookup

          %form{ action: "/", method: "get" }
            %input{ type: "text", name: "q" }
            %input{ type: "submit", value: "Search"}

    HERE

    file "Gemfile", <<HERE.gsub('^\s+', '')

    HERE

    generate_files
  end

  private

  def generate_files
    @files.each do |content|
      File.open(file, "w") do |f|
        f.write content
      end
    end
  end

  def dir(path)
    ex "mkdir -p #{path}"
  end

  def file(name, content)
    @files << { name: name, content: content }
  end

  def ex(cmd)
    puts cmd
    out = `#{cmd}`
    puts out
    out
  end

end


Sinatrize.generate
