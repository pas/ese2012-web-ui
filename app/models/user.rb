  require 'rubygems'
  require 'require_relative'
  require '../app/models/item'

  class User

    INITIAL_CREDIT = 100
    @@users = []

    # generate getter and setter for name and grades
    attr_accessor :name, :credits, :items, :password

    # User should always have a name
    # User should own all items he posses
    # User should not have negative amount of money
    def invariant
      fail 'Missing name for ' + self.to_s if (self.name == nil)
      fail self.to_s + ' does not own all its objects he posses' unless self.items.all? { |item| item.owner == self }
      fail self.to_s + ' does have a negative amount of money' if self.credits < 0
    end

    # factory method (constructor) on the class
    def self.named( name, password_new )
      user = self.new
      user.name = name
      user.password = password_new
      user.credits = INITIAL_CREDIT

      user.invariant
      user
    end

    def authenticate?(input)
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

      self.invariant
    end

    def remove_item( name )
      self.items = items.delete_if { |item| item.name == name }

      self.invariant
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
      item = self.items.detect { |item| item.name == item_name }
      !item.nil? && item.is_active?
    end

    def sell( item_name, buyer)
      item = self.items.select { |item| item.name == item_name }.pop

      if item.nil?
        fail "Transaction failed because #{name} does not own \'#{item_name}\'"
      elsif ! item.is_active?
        fail "Transaction failed because #{name} does not sale \'#{item_name}\'"
      elsif buyer.credits < item.price
        fail "Transaction failed because #{buyer.name} does not have enough money"
      end

      buyer.credits -= item.price
      self.credits += item.price
      self.items.delete(item)
      item.owner = buyer
      buyer.add_item(item)

      self.invariant
    end

    def add_item( item )
      self.items.push(item)

      self.invariant
    end

    def self.all
      @@users
    end

    def self.by_name name
      @@users.detect {|user| user.name == name }
    end

    def save
      @@users << self
    end
  end