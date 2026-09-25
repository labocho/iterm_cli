$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "iterm_cli"

Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each {|file| require file }
