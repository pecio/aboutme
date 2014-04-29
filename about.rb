require 'sinatra'
require 'i18n'
require 'rack/contrib'

use Rack::Locale

get '/' do
  File.new('public/index.html').readlines
end
