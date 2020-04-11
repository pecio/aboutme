require 'sinatra'

disable :run

require './about.rb'

use Rack::Deflater

run Sinatra::Application
