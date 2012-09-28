require 'rubygems'
require 'require_relative'
require 'test/unit'
require 'helper'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

require '../app/app'
require '../app/models/user'

class MainTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    App
  end

  describe 'Main subclasses' do
    class TestApp < App
      configure do
        bart = User.named('Bart' , 'bart')
        bart.create_item('Skateboard', 100)
        bart.create_item('Elephant', 150)
        bart.create_item('Knecht Ruprecht', 10)
        bart.offer('Elephant')
        bart.offer('Skateboard')

        homer = User.named('Homer', 'homer')
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

    it 'include test data' do
      assert(! User.all.empty?, 'There should be test data!')
    end

    it 'get /home' do
      get '/home', {}, 'rack.session' => { :name => 'Bart' }
      puts last_response.body
      assert last_response.ok?
      assert last_response.body.include?('Bart')
    end
  end
end