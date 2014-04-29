require 'sinatra'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'rack/contrib'
require 'pony'

configure do
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.backend.load_translations
end

use Rack::Locale

before '/:locale/*' do
  I18n.locale       =       params[:locale]
  @lang_uri         =       params[:locale]
  request.path_info = '/' + params[:splat ][0]
end

helpers do
  def find_template(views, name, engine, &block)
    I18n.fallbacks[I18n.locale].each { |locale| super(views, "#{name}.#{locale}", engine, &block) }
    super(views, name, engine, &block)
  end

  def t(*args)
    I18n.t(*args)
  end

  def l(*args)
    I18n.l(*args)
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

get '/contactform.js' do
  erb 'contactform.js'.to_sym, layout: false
end

post '/contact' do
  options = {
    to: 'pedroche@me.com',
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
