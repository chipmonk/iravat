require 'faker'
  namespace :db do
    desc "Fill database with sample data"
  
    task :populate => :environment do
      Rake::Task['db:reset'].invoke
      User.create!(:name => "Example User",
                  :email => "example@railstutorial.org",
                  :password => "foobar",
                  :password_confirmation => "foobar")
      9.times do |n|
        name = Faker::Name.name
        email = "example-#{n+1}@railstutorial.org"
        password = "password"
        User.create!(:name => name,
          :email => email,
          :password => password,
          :password_confirmation => password)
      end
      n = 0
      User.all(:limit => 6).each do |user|
      50.times do
        n = n+1
        user.machines.create!(:instance => Faker::Lorem.sentence(5))
      end
    end
  end
end
