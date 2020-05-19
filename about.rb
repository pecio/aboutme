require 'sinatra'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'pony'
require 'user_locale'
require 'tilt/erb'

configure do
  I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.enforce_available_locales = true
  I18n.default_locale = :en
  I18n.backend.load_translations
  set :static_cache_control, [:public, :max_age => 2592000]
end

use Rack::UserLocale, :accepted_locales => I18n.available_locales

before '/' do
  redirect "/#{I18n.locale}/"
end

before '/:document' do
  redirect "/#{I18n.locale}/#{params[:document]}"
end

before '/:locale/*' do
  if I18n.locale_available?(params[:locale]) then
    I18n.locale     =       params[:locale]
  end
  @lang_uri         =       params[:locale]
  request.path_info = '/' + params[:splat ][0]
end

helpers do
  def t(*args)
    I18n.t(*args)
  end

  def l(*args)
    I18n.l(*args)
  end
end

before do
  response.headers['X-Clacks-Overhead'] = 'GNU Terry Pratchett'
end

get '/' do
  erb "index-#{I18n.locale}".to_sym
end

get '/resume' do
  erb "resume-#{I18n.locale}".to_sym
end

get '/extended' do
  erb "extended-#{I18n.locale}".to_sym
end

get '/contact' do
  erb :contact
end

get '/contactform.js' do
  erb 'contactform.js'.to_sym, layout: false
end

post '/contact' do
  options = {
    to: ENV['CONTACT_ADDRESS'],
    from: "#{params[:name]} <#{params[:email]}>",
    subject: 'Contacto de ' + params[:name],
    body: params[:message],
    charset: 'UTF-8',
    via: :smtp,
    via_options: {
      port:           ENV['MAILGUN_SMTP_PORT'],
      address:        ENV['MAILGUN_SMTP_SERVER'],
      user_name:      ENV['MAILGUN_SMTP_LOGIN'],
      password:       ENV['MAILGUN_SMTP_PASSWORD'],
      authentication: :plain
    }
  }

  Pony.mail(options)

  erb :contact
end
