# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
secrets = YAML.load_file(File.expand_path("../secrets.yml", __FILE__))
Wallsome::Application.config.secret_token = secrets[:secret_token]
