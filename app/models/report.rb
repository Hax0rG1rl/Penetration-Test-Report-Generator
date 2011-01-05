class Report < ActiveRecord::Base
has_many :vulnerabilities
belongs_to :user
belongs_to :client
end
