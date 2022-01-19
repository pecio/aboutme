workers Integer(ENV['WEB_CONCURRENCY'] || 0)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

if not ENV['GOOGLE_CLOUD_PROJECT']
  bind "unix://./run/puma.sock?umask=0000"
end