class User < ActiveRecord::Base

	has_many :microposts, dependent: :destroy

	before_save{self.email = email.downcase}
	before_create :create_remember_token

	validates(:name, presence:true, length: {maximum: 50} )	
	validates(:email, presence:true, format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i}, uniqueness: {case_sensitive: false})
	has_secure_password
	validates(:password, length: {minimum: 6}) #presence validation automatically added by has_secure_password method

	def User.new_remember_token
      SecureRandom.urlsafe_base64
    end

    def User.encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
    end

    def feed
    	microposts
    end

    private

	    def create_remember_token
	      self.remember_token = User.encrypt(User.new_remember_token)
	    end
end
