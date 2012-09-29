  require 'rubygems'
  require 'require_relative'
  require '../app/models/item'

  # An instance of User represents a person that owns, sells or buys
  # Items of other Users.
  # An instance User is identified through its name.
  #
  # @@users contains all users.
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
      fail 'Name not defined' if name == nil

      user = self.new
      user.name = name
      user.password = password_new
      user.credits = INITIAL_CREDIT

      user.invariant
      user
    end

    # Checks if input == password of this User.
    #
    # @param [String] input
    def authenticate?(input)
      input == self.password
    end

    def initialize
      self.items = Array.new
    end

    # String representation of an user, giving its name and
    # the amount of credit.
    #
    # Example: "John 100"
    def to_s
      "#{name} #{credits}"
    end

    # Creates a new Item and adds it to this Users list.
    # A newly created Item is initially inactive.
    #
    # @return [String] name of item.
    # @param [Float] (positiv) price of item.
    def create_item( name, price )
      fail "Name not defined" if name == nil
      fail "Price not defined" if price == nil
      fail "Price can not be negative" if price < 0

      items.push(Item.create(self, name, price))

      self.invariant
    end

    # Removes (all) item(s) with name "name" from @items.
    #
    # @return [String] name of item.
    def remove_item( name )
      fail 'Name not defined' if name == nil
      fail 'Object does not exist' if items.detect{ |item| item.name == name }==nil

      self.items = items.delete_if { |item| item.name == name }

      self.invariant
    end

    # Returns true if the user posses the item with the
    # given name.
    # @param [String] name of item.
    def owns?( name )
       fail 'Name not defined' if name == nil

       item = self.items.detect{ |item| item.name == name }

       !item.nil? && item.owner == self
    end

    
    # Activates item with name "name".
    # Only an activated item may be bought by an other user.
    def offer( name )
      self.items.detect{ |item| item.name == name}.activate
    end

    # Returns all active items of this user.
    def offers
      self.items.select { |item| item.is_active? }
    end

    # Checks if item with name "item_name" is for sale.
    # (for testing purpose only)
    def sells?( item_name )
      item = self.items.detect { |item| item.name == item_name }
      !item.nil? && item.is_active?
    end

    # A transaction of selling an item may fail for the following
    # reasons:
    #
    # - The seller (self) does not own an item with name "item_name"
    # - The item with name "item_name" is not activated and therefore
    # not for sale
    # - The buyer has less credit than the price of the item.
    #
    # If none of this fails, then the transaction takes place. The price
    # of the item is payed by the buyer to the seller (self) and the ownership
    # of the item is changed accordingly. Additionally the items status is
    # set back to inactive.
    #
    # @param [String] item_name
    # @param [User] buyer
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
      item.deactivate()
      buyer.add_item(item)

      self.invariant
    end

    # @param [Item] item to be added.
    def add_item( item )
      self.items.push(item)

      self.invariant
    end

    def self.all
      @@users
    end

    # Class method.
    #
    # @param [String] name of user.
    # @return [User] first found user.
    def self.by_name name
      @@users.detect {|user| user.name == name }
    end

    # Add an self to users.
    def save
      @@users << self
    end
  end