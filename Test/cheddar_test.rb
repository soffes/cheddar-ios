require 'rubygems'
require 'appium_lib'

APP_PATH = '/Users/austenkeene/Desktop/Cheddar copy.app'

capabilities = {
    platformName:  'iOS',
    versionNumber: '7.1',
    app:           APP_PATH,
    deviceName: 'IOS',
}

server_url = "http://0.0.0.0:4723/wd/hub"

Appium::Driver.new(caps: capabilities).start_driver
Appium.promote_appium_methods Object

sleep 5

find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIATextField[1]").click
find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIATextField[1]").send_keys "test123456789"


find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIASecureTextField[1]").click
find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIASecureTextField[1]").send_keys "test123456789"


find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIAButton[1]").click

sleep 4

# Temporary fix
swipe :start_x => 76, :start_y => 96, :end_x => 80, :end_y => 96, :touchCount => 1, :duration => 500

sleep 2

find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIALink[5]/UIAStaticText[1]").click
find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIATextField[1]").send_keys "My List"
find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIAButton[1]").click

sleep 2

find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIATextField[1]").click
find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIATextField[1]").send_keys "My item 123"

find_element(:name=>'Go', :window=>'keyboard').click

sleep 2

find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIALink[5]").click
find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIALink[8]/UIAStaticText[1]").click

sleep 1

find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIAScrollView[1]/UIAWebView[1]/UIAButton[2]").click

sleep 4

driver_quit
