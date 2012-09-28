require 'rubygems'
require 'require_relative'
require 'sinatra'
require 'haml'
require '../app/models/user'

class Main < Sinatra::Application
  get '/' do
    redirect '/login' unless session[:name]
    redirect '/home'
  end

  get '/home' do
    redirect '/login' unless session[:name]
    haml :home, :locals => { :name => session[:name], :users => User.all }
  end
end