require 'google/cloud/secret_manager' if ENV['GOOGLE_CLOUD_PROJECT']

def get_secret(name)
    def fallback(name)
        if File.exist?("/run/secrets/#{name}")
            File.read("/run/secrets/#{name}").chomp
        else
            ENV[name.upcase]
        end
    end

    project = ENV['GOOGLE_CLOUD_PROJECT']
    path = "projects/#{project}/secrets/#{name}/versions/latest"
    if project
        begin
            client = Google::Cloud::SecretManager.secret_manager_service
            response = client.access_secret_version name: path  
            response.payload.data  
        rescue
            fallback(name)
        end
    else
        fallback(name)
    end
end