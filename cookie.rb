# -*- coding: utf-8 -*-
require 'selenium-webdriver'

class Product
  attr_reader :name, :price, :quantity

  def initialize(element)
    @element = element
    @name = @element.find_element(:class => "title").text
    @price = @element.find_element(:class => "price").text.to_i
    owned = @element.find_elements(:class => "owned")
    @quantity = 0
    @quantity = owned.first.text.to_i unless owned.empty?
  end

  def buy
    @element.click
    sleep 0.1
  end

end

class CookieBaker

  def initialize
    @driver = Selenium::WebDriver.for :chrome
    @driver.navigate.to "http://orteil.dashnet.org/cookieclicker/"
    @driver.manage.window.move_to(0, 0)
    @driver.manage.window.resize_to(1024, 768)
  end

  def fetch_elements
    @big_cookie = @products = nil
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until { 
      @big_cookie = @driver.find_element(:id => "bigCookie")
      @products = @driver.find_element(:id => "products")
    }
  end

  def bake
    fetch_elements
    while true
      next if @big_cookie.nil?
      @big_cookie.click
      @products.find_elements(:class => "enabled").reverse.each do |element|
        product = Product.new(element)
        if product.price * (product.quantity ** 2) < get_cookie_count
          product.buy
          fetch_elements
          puts "Buy #{product.name}"
          break
        end
      end
    end 
  end

  def get_cookie_count
    /^([0-9]+)/ =~ @driver.find_element(:id, :cookies).text
    $1.to_i
  end

end

baker = CookieBaker.new
baker.bake
