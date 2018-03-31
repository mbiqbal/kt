source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
ruby '2.4.0'
gem 'rails', '~> 5.1.3'
gem 'puma', '~> 3.7'
gem 'jbuilder', '~> 2.5'
gem 'pg'
gem 'secondbase'
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end
group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'high_voltage'
group :development do
  gem 'better_errors'
  gem 'rails_layout'
end
group :development, :test do
  gem 'factory_bot'
  gem 'factory_bot_rails'
end
group :test do
  gem 'shoulda-matchers'
  gem 'shoulda-callback-matchers'
  gem 'rspec-rails', '~> 3.7'
end
