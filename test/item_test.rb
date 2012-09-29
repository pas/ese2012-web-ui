require "rubygems"
require "require_relative"
require "test/unit"
require "../app/models/item"
require "../app/models/user"
require "test_description_simplifier"

class ItemTest < Test::Unit::TestCase

  def get_item_house
    user = create_user()
    Item.create(user, 'house', 100)
  end

  should "have a name" do
    item =  get_item_house
    assert( item.name == 'house', "Item should be called \'house\' but was #{item.name} instead")
  end

  should "have a price" do
    item =  get_item_house
    assert( item.price == 100, "Item should cost \'100\' but was #{item.price} instead")
  end

  should "be inactive at start" do
    item =  get_item_house
    assert(! item.is_active?, 'Item should be inactive after creation.')
  end

  should "be set active" do
    item =  get_item_house
    item.activate()
    assert(item.is_active?, 'Item should be activated.')
  end

  should "inactive when switched activate-deactivate" do
    item =  get_item_house
    item.activate()
    assert(item.is_active?, 'Item should be activated.')
    item.deactivate()
    assert(! item.is_active?, 'Item should be deactivated.')
  end

  should "have owner" do
    user = User.named('john', 'nhoj')
    item = Item.create(user, 'house', 100)
    assert(item.owner == user, "Jane should be owner.")
  end

  def create_user()
    User.named('Jane', 'jane')
  end

end