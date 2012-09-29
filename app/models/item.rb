  # An instance of Item is owned by exactly one instance of User.
  # Items are identified by their name.
  # Items can be bought and sold by between different users.
  # The price of an Item is payed by the buyer with credits.
  #
  # A new Item should be instantiated by calling the method self.create.

  class Item
    # generate getter and setter for name and grades
    attr_accessor :name, :price, :owner

    # Access only through activate() and deactivate()
    @active

    # Item should always have a owner, a price and
    # a name
    def invariant
      fail 'Missing owner for ' + self if (self.owner == nil)
      fail 'Missing name for ' + self if (self.name == nil)
      fail 'Missing price for ' + self if (self.price == nil)
    end

    # factory method (constructor) on the class Item
    # @param [User] owner
    # @param [String] name
    # @param [Float] price
    def self.create( owner, name, price )
      item = self.new
      item.name = name
      item.price = price
      item.owner = owner

      item.invariant()
      item
    end

    def initialize
      @active = FALSE
    end

    def is_active?
      @active
    end

    def activate
      @active = TRUE
    end

    def deactivate
      @active = FALSE
    end

    def to_s
      "#{name.capitalize} costs #{price} credits"
    end
  end