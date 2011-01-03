class Client < ActiveRecord::Base
	has_many :pentests
	has_many :users, :through => :pentests
end
