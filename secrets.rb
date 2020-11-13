require 'google/cloud/secret_manager' if ENV['GOOGLE_CLOUD_PROJECT']

class SecretStore
    include Singleton

    def initialize
        @secrets = {}

        if ENV['GOOGLE_CLOUD_PROJECT']
            begin
                @client = Google::Cloud::SecretManager.secret_manager_service
            rescue
                @client = nil
            end
        else
            @client = nil
        end

        for name in [
            'google_analytics_id',
            'contact_address',
            'smtp_login',
            'smtp_password',
            'smtp_server',
            'smtp_port'
        ]
            @secrets[name] = _get(name)
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
        def fallback(name)
            if File.exist?("/run/secrets/#{name}")
                File.read("/run/secrets/#{name}").chomp
            else
                ENV[name.upcase]
            end
        end
    
        project = ENV['GOOGLE_CLOUD_PROJECT']
        path = "projects/#{project}/secrets/#{name}/versions/latest"
        if @client
            begin
                response = @client.access_secret_version name: path  
                response.payload.data  
            rescue
                fallback(name)
            end
        else
            fallback(name)
        end
    end
end

def get_secret(name)
    SecretStore.instance.get(name)
end