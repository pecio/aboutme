require 'sinatra'

# For Heroku logging
$stdout.sync = true

disable :run

require './about.rb'

use Rack::Deflater

run Sinatra::Application
