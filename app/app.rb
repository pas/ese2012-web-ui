require 'rubygems'
require 'sinatra'
require 'haml'
require 'require_relative'
require_relative 'models/user'
require_relative 'controllers/main'
require_relative 'controllers/authentication'


class App < Sinatra::Base
  set :public_folder, '/public'

  use Authentication
  use Main

  enable :sessions unless ENV['RACK_ENV'] == 'test'

  configure :development do
    bart = User.named('Bart' , 'Bart')
    bart.create_item('Skateboard', 100)
    bart.create_item('Elephant', 150)
    bart.create_item('Knecht Ruprecht', 10)
    bart.offer('Elephant')
    bart.offer('Skateboard')

    homer = User.named('Homer', 'Homer')
    homer.create_item('Beer', 200)
    homer.create_item('Nuclear Crisis', 100)
    homer.create_item('Sofa', 50)
    homer.offer('Nuclear Crisis')

    ese = User.named('ese', 'ese')
    ese.create_item('Introduction to Ruby', 100)
    ese.create_item('Knowledge', 50)
    ese.offer('Knowledge')
    ese.offer('Introduction to Ruby')

    bart.save
    homer.save
    ese.save
  end
end

App.run! unless ENV['RACK_ENV'] == 'test'