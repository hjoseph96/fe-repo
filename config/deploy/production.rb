set :stage, :production
set :rails_env, :production
set :branch, "main"
server "162.213.38.159", user: "cloudsigma", roles: %w{web app db}
