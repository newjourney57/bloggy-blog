$redis = if Rails.env.development?
  Redis.new(host: 'localhost', post: 6379)
else
  Redis.new(url: ENV["REDISCLOUD_URL"])
end

I18n.backend = I18n::Backend::KeyValue.new($redis)

Idioma.configure do |configure|
  configure.redis_backend = I18n.backend

  # Globalize was having problems with db migrations
  # because of this code
  if ENV["MIGRATE"] != "true"
    configure.default_locale = -> {
      Setting.get(:i18n_default_locale).to_sym
    }

    configure.locales = -> {
      Setting.get(:i18n_available_locales).split(",").map { |locale| locale.strip.to_sym }
    }
  end
end