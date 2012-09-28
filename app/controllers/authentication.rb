require 'rubygems'
require 'require_relative'
require 'sinatra'
require 'haml'
require '../app/models/user'

class Authentication < Sinatra::Application
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
        session[:name] = name
        redirect '/home'
      else
        "You are a hacker!"
      end
    end
  end
end