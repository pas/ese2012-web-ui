require 'rubygems'
require 'sinatra'
require 'haml'

require 'require_relative'
require_relative '../models/user'

class Authentication < Sinatra::Application
  get '/login' do
    haml :login
  end

  get '/logout' do
    session[:name] = nil
    redirect '/login'
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