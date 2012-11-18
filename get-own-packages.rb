#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require 'net/http'
require 'net/https'
require 'json'

# CONFIGURATION:
$maintainer = 'cookies'

http = Net::HTTP.new('aur.archlinux.org', 443)
http.use_ssl = true
resp = http.get('/rpc.php?type=msearch&arg=' + $maintainer, {})
json = JSON.parse(resp.body)
case json['type']
  when 'msearch'
    puts "----------------------------------------------------------"
    json['results'].each {
      |pkg|
      if pkg['OutOfDate'] != 0
        print "(!) "
      end
      puts pkg['Name'] + " " + pkg['Version'] + ":"
      puts "  https://aur.archlinux.org/packages.php?ID=" + pkg['ID'].to_s()
      puts "  " + pkg['URL']
      puts "----------------------------------------------------------"
    }
  when 'error'
    puts "API ERROR: " + json['results']
end
