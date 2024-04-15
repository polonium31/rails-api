require 'securerandom'

secret_key = SecureRandom.hex(32)

ENV['APP_SECRET_KEY'] = secret_key