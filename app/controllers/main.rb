require 'rubygems'
require 'require_relative'
require 'sinatra'
require 'haml'

class Main < Sinatra::Application
  get '/home' do
    #redirect '/login' unless session[:name]
    "Yes!" + session[:name].to_s
  end
end