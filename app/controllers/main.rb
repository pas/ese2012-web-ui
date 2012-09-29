require 'rubygems'
require 'require_relative'
require 'sinatra'
require 'haml'
require '../app/models/user'

class Main < Sinatra::Application

  before do
    redirect '/login' unless session[:name]
  end

  get '/' do
    redirect '/home'
  end

  get '/home' do
    haml :home, :locals => { :user => User.by_name(session[:name]), :users => User.all }
  end

  get '/items' do
    haml :my_items, :locals => { :user => User.by_name(session[:name]), :items => User.by_name(session[:name]).items}
  end

  post '/buy' do
    buyer = User.by_name(params[:buyer])
    seller = User.by_name(params[:seller])

    fail "#{buyer.name} is not logged in!" if (session[:name] != buyer.name)

    seller.sell(params[:product], buyer)
    redirect '/home'
  end

  get '/:name' do
    name = params[:name]
    haml :user, :locals => { :name => session[:name], :user => User.by_name(name)}
  end
end