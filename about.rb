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

helpers do
  def find_template(views, name, engine, &block)
    I18n.fallbacks[I18n.locale].each { |locale| super(views, "#{name}.#{locale}", engine, &block) }
    super(views, name, engine, &block)
  end
end

get '/' do
  erb :index
end

get '/resume' do
  erb :resume
end

get '/contact' do
  erb :contact
end
