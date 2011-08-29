# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'bcrypt'

class User < ActiveRecord::Base
	include BCrypt
	attr_accessor :password
	attr_accessible :name, :email, :password, :password_confirmation
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	has_many :posts, :dependent => :destroy
	has_many :relationships, :foreign_key => "follower_id",
							 :dependent => :destroy
	has_many :following, :through => :relationships, :source => :followed
	has_many :reverse_relationships, :foreign_key => "followed_id",
									 :class_name => "Relationship",
									 :dependent => :destroy
	has_many :followers, :through => :reverse_relationships, :source => :follower
	validates :name,  	:presence 	=> true
	validates :email, 	:presence 	=> true,
						:format 	=> { :with => email_regex },
						:uniqueness => { :case_sensitive => false }
	validates :password,:presence	=> true,
						:confirmation => true,
						:length		=> { :within => 6..255 }
	before_save :encrypt_password

	def has_password?(submitted_password)
		return (Password.new(encrypted_password) == submitted_password)
		#compare encrypted with submitted
	end
	
	def following?(followed)
		relationships.find_by_followed_id(followed)
	end

	def follow!(followed)
		relationships.create!(:followed_id => followed.id)
	end

	def unfollow(followed)
		relationships.find_by_followed_id(followed).destroy
	end

	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end
	def self.authenticate_with_pass(id, submitted_password)
		user = find_by_id(id)
		return nil if user.nil?
		return user if(user.encrypted_password == submitted_password)
	end
	def feed
		Post.from_users_followed_by(self)
	end

	private

		def encrypt_password
			self.encrypted_password = Password.create(password)
		end

		def encrypt(string)
		  string
		end
		end
