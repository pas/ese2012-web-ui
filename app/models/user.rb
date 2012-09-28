  require 'rubygems'
  require 'require_relative'
  require '../app/models/item'

  class User

    INITIAL_CREDIT = 100
    @@users = []

    # generate getter and setter for name and grades
    attr_accessor :name, :credits, :items, :password

    # factory method (constructor) on the class
    def self.named( name, password_new )
      user = self.new
      user.name = name
      user.password = password_new
      user.credits = INITIAL_CREDIT
      user
    end

    def authenticate?(input)
      puts "input: #{input}, password: " + self.password
      input == self.password
    end

    def initialize
      self.items = Array.new
    end

    def to_s
      "#{name} #{credits}"
    end

    def create_item( name, price )
      items.push(Item.create(self, name, price))
    end

    def remove_item( name )
      self.items = items.delete_if { |item| item.name == name }
    end

    def owns?( item_name )
       item = self.items.select { |item| item.name == item_name }.pop
       !item.nil? && item.owner == self
    end

    def offer( name )
      self.items.each { |item| item.name == name ? item.activate : nil }
    end

    def offers()
      self.items.select { |item| item.is_active? }
    end

    def sells?( item_name )
      item = self.items.select { |item| item.name == item_name }.pop

      !item.nil? && item.is_active?
    end

    def sell( item_name, buyer)
      item = self.items.select { |item| item.name == item_name }.pop

      if item.nil?
        puts "Transaction failed because #{name} does not own \'#{item_name}\'"
        return FALSE
      elsif ! item.is_active?
        puts "Transaction failed because #{name} does not sale \'#{item_name}\'"
        return FALSE
      elsif buyer.credits < item.price
        puts "Transaction failed because #{buyer.name} does not have enough money"
        return FALSE
      end

      buyer.credits -= item.price
      self.credits += item.price
      self.items.delete(item)
      buyer.add_item(item)
      item.owner = buyer
      TRUE
    end

    def add_item( item )
      self.items.push(item)
    end

    def self.all
      @@users
    end

    def self.by_name name
      @@users.detect {|user| user.name == name }
    end

    def save
      @@users << self # or @@students.push(self)
    end

  end