require_relative 'lib/utils'
require_relative 'lib/rpm'

USAGE = "usage: ruby rpm.rb <request.json>"
if ARGV.empty?
  puts USAGE
else
  if ARGV.length == 1
    file = ARGV.first
    if File.exists?(file)
      attrs = JSON.parse(File.read(file), symbolize_names: true)
      main(attrs)
    else
      puts "No such file: #{file}"
    end
  else
    puts USAGE
  end
end
