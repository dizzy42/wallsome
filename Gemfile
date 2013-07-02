source :rubygems

gem "rails", :git => 'https://github.com/rails/rails.git', :branch => '3-0-stable'
gem "nokogiri"
gem "sqlite3-ruby", "1.2.5", :require => "sqlite3", :group => [:development, :test]
gem "rspec-rails", "~>2.0.1", :group => [:development, :test]

group :test do
  gem "mocha"
  gem "database_cleaner"
  gem "factory_girl_rails", "1.0"
end

group :production do
  gem "mysql"
end

group :deployment do
  gem "capistrano"
  gem "cap_gun", :git => "git://github.com/relevance/cap_gun.git", :ref => "ceb90ad"
end
