class User < ActiveRecord::Base
  attr_accessible :login, :password, :password_confirmation, :email, :role_ids

  acts_as_authentic do |c|
    c.logged_in_timeout = 30.minutes # default is 10.minutes
  end

  has_many :articles
  has_many :comments
  has_many :assignments
  has_many :roles, :through => :assignments
  has_many :comments

  def role_symbols
    (roles || []).map {|r| r.name.to_sym}
  end

  def is_admin?
    current_roles=UserSession.find.record.roles.map(&:name) rescue []
    current_roles.detect {|role| role == "admin"}
  end
end
