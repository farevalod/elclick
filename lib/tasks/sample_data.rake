namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
	admin = User.create!(:name => "sp",
					 :email => "sp@4ws.cl",
					 :password => "cacapupu",
					 :password_confirmation => "cacapupu")
	admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@elclick.cl"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)

	 User.all(:limit => 6).each do |user|
	 	15.times do
			user.posts.create!(:content => Faker::Lorem.sentence(5))
		end
	 end
    end
  end
end
