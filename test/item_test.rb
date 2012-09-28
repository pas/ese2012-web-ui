require "rubygems"
require "require_relative"
require "test/unit"
require "../app/models/item"
require "../app/models/user"

class ItemTest < Test::Unit::TestCase
  def get_item_house
    user = create_user()
    Item.create(user, 'house', 100)
  end

  def test_should_have_a_name
    item =  get_item_house
    assert( item.name == 'house', "Item should be called \'house\' but was #{item.name} instead")
  end

  def test_should_have_a_price
    item =  get_item_house
    assert( item.price == 100, "Item should cost \'100\' but was #{item.price} instead")
  end

  def test_should_be_inactive_start
    item =  get_item_house
    assert(! item.is_active?, 'Item should be inactive after creation.')
  end

  def test_should_be_active
    item =  get_item_house
    item.activate()
    assert(item.is_active?, 'Item should be activated.')
  end

  def test_should_be_inactive
    item =  get_item_house
    item.activate()
    assert(item.is_active?, 'Item should be activated.')
    item.deactivate()
    assert(! item.is_active?, 'Item should be deactivated.')
  end

  def test_item_should_have_owner
    user = User.named('john', 'nhoj')
    item = Item.create(user, 'house', 100)
    assert(item.owner == user, "Jane should be owner.")
  end

  def create_user()
    User.named('Jane', 'jane')
  end

end