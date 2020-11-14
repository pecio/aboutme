require 'google/cloud/secret_manager' if ENV['GOOGLE_CLOUD_PROJECT']

class SecretStore
    include Singleton

    def initialize
        @secrets = {}

        if ENV['GOOGLE_CLOUD_PROJECT']
            begin
                @client = Google::Cloud::SecretManager.secret_manager_service
            rescue => e
                puts "Could not create SecretManager: #{e}"
                @client = nil
            end
        else
            @client = nil
        end
    end

    def get(name)
        if @secrets[name]
            @secrets[name]
        else
            @secrets[name] = _get(name)
        end
    end

    private
    def _get(name)
        if File.exist?("/run/secrets/#{name}")
            File.read("/run/secrets/#{name}").chomp
        elsif ENV[name.upcase]
            ENV[name.upcase]
        elsif @client
            project = ENV['GOOGLE_CLOUD_PROJECT']
            path = "projects/#{project}/secrets/#{name}/versions/latest"
   
            begin
                response = @client.access_secret_version name: path  
                response.payload.data  
            rescue => e
                puts "Could not get #{path}: #{e}"
            end
        else
            nil
        end
    end
end

def get_secret(name)
    SecretStore.instance.get(name)
end