require 'ostruct'
require 'optparse'
require 'json'

module Setup

  class Commander

    attr_accessor :options

    def initialize (argv)
      @options = OpenStruct.new

      @option_parser = OptionParser.new do |op|
        op.banner = "Usage: setup options"

        op.on_tail('-h','--help') do |argument|
          puts op
          exit
        end
      end

      @option_parser.parse!(argv)
      options.terms = argv # must be after parse!
    end

    def valid?
      true
    end

    def help
      puts @option_parser
      exit
    end

    def execute
      contents = File.read(File.join('dotfiles','bash_profile')).split("\n")

      File.open(File.join(ENV['HOME'], '.bash_profile'), "a") do |f|
        f.puts
        f.puts "# added by ~/GitHub/rkiel/bash-utilities/install/bin/setup"
        contents.each { |line| f.puts line }
        f.puts
      end

      File.open(File.join(ENV['HOME'], '.bashrc'), "a") do |f|
        f.puts
        f.puts "# added by ~/GitHub/rkiel/bash-utilities/install/bin/setup"
        f.puts 'source ~/GitHub/rkiel/bash-utilities/dotfiles/bashrc'
        f.puts
      end

    end

    private

    def run_cmd ( cmd )
      puts
      puts cmd
      success = system cmd
      unless success
        error "(see above)"
      end
      puts
    end

    def error ( msg )
      puts
      puts "ERROR: #{msg}"
      puts
      exit
    end

  end

end
