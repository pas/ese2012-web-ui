require 'rubygems'
require 'require_relative'
require 'sinatra'
require '../app/models/user'

class Authentication
  get '/login' do
    haml :login
  end

  post '/login' do
    name = params[:username]
    password = params[:password]

    user = User.by_name(name)
    if user == nil
      "User does not exist!"
    else
      if user.authenticate?(password)
        "Bravo, you're logged in"
      else
        "You are a hacker!"
      end
    end
  end

  get '/*' do
    redirect '/login'
  end
end