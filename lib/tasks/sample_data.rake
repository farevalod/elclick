namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_posts
    make_relationships
  end
end

def make_users
  admin = User.create!(:name => "Francisco Arevalo",
                       :email => "sp@4ws.cl",
                       :password => "cacapupu",
                       :password_confirmation => "cacapupu")
  admin.toggle!(:admin)
  15.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_posts
  User.all(:limit => 6).each do |user|
    5.times do
      content = Faker::Lorem.sentence(5)
      user.posts.create!(:content => content)
    end
  end
end

def make_relationships
  users = User.all
  user  = users.first
  following = users[1..8]
  followers = users[2..10]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
