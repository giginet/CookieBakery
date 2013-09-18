# -*- coding: utf-8 -*-
require 'selenium-webdriver'

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
      @products = @driver.find_elements(:class => "product")
    }
  end

  def bake
    fetch_elements
    while true
      next if @big_cookie.nil?
      @big_cookie.click
      @products.each do |product|
        classes = product.attribute('class').split()
        if classes.include?('enabled')
          product_name = product.find_element(:class => "title").text
          puts "use #{product_name}"
          product.click
          wait = Selenium::WebDriver::Wait.new(:timeout => 10)
          sleep 0.1
          fetch_elements
        end
      end
    end 
  end
end

baker = CookieBaker.new
baker.bake
