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

    file "config/env.rb", <<-STR.gsub(/^\s+/, '')
      require 'bundler/setup'
      Bundler.require :default
    STR

    file "Gemfile", <<-STR.gsub(/^\s+/, '')
      source "http://rubygems.org"

      gem "sinatra", github: "sinatra/sinatra"

      gem 'sucker_punch', '~> 1.0'

    STR

    file "app.rb", <<-STR.gsub(/^ {6}/, '')
      require_relative "../config/env"

      class ReverseWhois
        get "/" do
          haml :index
        end
      end

    STR

    file "config.ru", <<-STR.gsub(/^\s+/, '')
      require "./reverse_whois"

      run ReverseWhois

    STR

    file "Readme.md", <<-STR.gsub(/^\s+/, '')
      # App.rb

      generated with makevoid/sinatrize_mini.rb
    STR

    file ".gitignore", <<-STR.gsub(/^\s+/, '')
      .sass-cache
      .DS_Store
    STR

    file "views/index.haml", <<-STR.gsub(/^ {6}/, '')
      %html
        %head
          %title Reverse whois lookup

        %body
          Reverse whois lookup

          %form{ action: "/", method: "get" }
            %input{ type: "text", name: "q" }
            %input{ type: "submit", value: "Search"}

      -# :)
    STR

    generate_files
  end

  private

  def generate_files
    @files.each do |file|
      File.open(file[:name], "w") do |f|
        f.write file[:content]
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
