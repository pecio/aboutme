require 'sinatra'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'rack/contrib'

configure do
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.backend.load_translations
end

use Rack::Locale

before '/:locale/*' do
  I18n.locale       =       params[:locale]
  request.path_info = '/' + params[:splat ][0]
end

get '/' do
  send_file File.expand_path('index.html', settings.public_folder)
end
