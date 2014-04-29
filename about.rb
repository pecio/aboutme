require 'sinatra'

get '/' do
  File.new('public/index.html').readlines
end
