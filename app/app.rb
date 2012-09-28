require 'rubygems'
require 'sinatra'
require 'require_relative'
require '../app/models/user'
require '../app/controllers/main'
require '../app/controllers/authentication'
require 'haml'

class App < Sinatra::Base

  enable :sessions

  use Authentication
  use Main

  configure :development do
    User.named('John' , 'john').save
  end
end