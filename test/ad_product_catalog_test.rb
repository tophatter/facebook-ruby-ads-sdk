require 'test_helper'

# rake test TEST=test/ad_product_catalog_test.rb
class AdProductCatalogTest < BaseTest
  def test_all
    vcr do
      catalogs = FacebookAds::AdProductCatalog.all
      catalog = catalogs.first
      assert_equal '197871307315718', catalog.id
      assert_equal 'Test', catalog.name
      assert_equal 'commerce', catalog.vertical
      assert_equal 1, catalog.product_count
      assert_equal 1, catalog.feed_count
    end
  end

  def test_create
    vcr do
      catalog = FacebookAds::AdProductCatalog.create(name: 'Foo Bar')
      assert_equal 'Foo Bar', catalog.name
      assert_equal 'commerce', catalog.vertical
      assert_equal 0, catalog.product_count
      assert_equal 0, catalog.feed_count
    end
  end

  def test_destroy
    vcr do
      catalog = FacebookAds::AdProductCatalog.find_by(name: 'Foo Bar')
      catalog.destroy
      assert_nil FacebookAds::AdProductCatalog.find_by(name: 'Foo Bar')
    end
  end
end
