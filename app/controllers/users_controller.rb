class UsersController < ApplicationController
  validates :username, :uniqueness => true, :length => { :minimum => 2 }
end
