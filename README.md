Instructions:

Clone The project

Run rvm gemset list that it is showing kt_assignement as selected gemset

$gem install bundler

$bundle

Setup project database by modifying database.yml

$bundle exec rake db:create

$bundle exec rake db:migrate

$bundle exec rake db:seed <Not needed if you only want to run tests>

To Test: $bundle exec rspec

To Run Archive Task: bundle exec rake kt:archive_old_trips