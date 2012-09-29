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

  describe 'Simple Tests' do
    class TestApp < App
      configure do
        bart = User.named('Bart' , 'bart')
        bart.create_item('Skateboard', 100)
        bart.offer('Skateboard')

        homer = User.named('Homer', 'homer')
        homer.create_item('Beer', 200)
        homer.offer('Beer')

        bart.save
        homer.save
      end
    end

    it 'include test data' do
      assert(! User.all.empty?, 'There should be test data!')
    end

    it 'should show login screen' do
      get '/home', {}, 'rack.session' => { :name => nil }
      assert last_response.redirect?
      assert last_response.location.include?('/login')
    end

    it 'get /home as Bart' do
      get '/home', {}, 'rack.session' => { :name => 'Bart' }
      assert last_response.ok?
      assert last_response.body.include?('We salute you Bart'), "Should salute bart"
      assert last_response.body.include?('Beer, 200 Credits'), "Should have beer to sell from homer"
    end

    it 'get /home as Homer' do
      get '/home', {}, 'rack.session' => { :name => 'Homer' }
      assert last_response.ok?
      assert last_response.body.include?('We salute you Homer'), "Should salute homer"
      assert last_response.body.include?('Skateboard, 100 Credits'), "Should have skateboard to sell from bart"
    end
  end
end