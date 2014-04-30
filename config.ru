require 'sinatra'

# For Heroku logging
$stdout.sync = true

disable :run

require './about.rb'

run Sinatra::Application
