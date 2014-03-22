use Rack::Static,
  :urls => ["/css", "/images", "/favicon.ico", "/resume.html", "/contact.html"],
  :root => "public"

run lambda { |env|
  [
    200,
    {
      'Content-Type'  => 'text/html; charset=utf-8',
      'Cache-Control' => 'public, max-age=86400'
    },
    File.open('public/index.html', File::RDONLY)
  ]
}
