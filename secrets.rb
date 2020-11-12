require 'google/cloud/secret_manager'

def get_secret(name)
    project = ENV['GOOGLE_CLOUD_PROJECT']
    path = "projects/#{project}/secrets/#{name}/versions/latest"
    begin
        client = Google::Cloud::SecretManager.secret_manager_service
        response = client.access_secret_version name: path  
        response.payload.data  
    rescue => exception
        if File.exist?("/run/secrets/#{name}")
            File.read("/run/secrets/#{name}")
        else
            ENV[name.upcase]
        end
    end
end