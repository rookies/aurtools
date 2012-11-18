#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require 'net/http'
require 'net/https'
require 'json'

# CONFIGURATION:
$maintainer = 'cookies'

# parse command line arguments:
skip_out_of_date = false
skip = Array.new
only = Array.new
i = 0
skip_next = false
ARGV.each {
  |arg|
  if skip_next == true
    skip_next = false
  else
    case arg
      when '--skip-out-of-date'
        skip_out_of_date = true
      when '--skip'
        if ARGV.length > i+1
          if ARGV[i+1].scan(',').length > 0
            x = ARGV[i+1].split(',')
            x.each {
              |y|
              skip << y
            }
            skip_next = true
          else
            skip << ARGV[i+1]
          end
        end
      when '--only'
        if ARGV.length > i+1
          if ARGV[i+1].scan(',').length > 0
            x = ARGV[i+1].split(',')
            x.each {
              |y|
              only << y
            }
            skip_next = true
          else
            only << ARGV[i+1]
          end
        end
    end
  end
  i += 1
}

http = Net::HTTP.new('aur.archlinux.org', 443)
http.use_ssl = true
resp = http.get('/rpc.php?type=msearch&arg=' + $maintainer, {})
json = JSON.parse(resp.body)
case json['type']
  when 'msearch'
    json['results'].each {
      |pkg|
      if not skip_out_of_date or pkg['OutOfDate'] == 0
        if (only.length > 0 and only.index(pkg['Name']) != nil) or only.length == 0
          if (skip.length > 0 and skip.index(pkg['Name']) == nil) or skip.length == 0
            puts pkg['Name']
          end
        end
      end
    }
    exit 0
  when 'error'
    puts "API ERROR: " + json['results']
    exit 1
end
