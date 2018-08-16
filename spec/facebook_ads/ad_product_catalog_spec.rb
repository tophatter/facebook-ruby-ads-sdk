# frozen_string_literal: true

require 'spec_helper'

describe FacebookAds::AdProductCatalog do
  # def test_all
  #   vcr do
  #     catalog = FacebookAds::AdProductCatalog.all.first
  #     assert_equal '197871307315718', catalog.id
  #     assert_equal 'Test', catalog.name
  #     assert_equal 'commerce', catalog.vertical
  #     assert_equal 1, catalog.product_count
  #     assert_equal 1, catalog.feed_count
  #   end
  # end
  #
  # def test_create
  #   vcr do
  #     catalog = FacebookAds::AdProductCatalog.create(name: 'Foo Bar')
  #     assert_equal 'Foo Bar', catalog.name
  #     assert_equal 'commerce', catalog.vertical
  #     assert_equal 0, catalog.product_count
  #     assert_equal 0, catalog.feed_count
  #     catalog = FacebookAds::AdProductCatalog.find(catalog.id)
  #     assert_equal true, catalog.destroy
  #     assert_nil FacebookAds::AdProductCatalog.find_by(name: 'Foo Bar')
  #   end
  # end
end
