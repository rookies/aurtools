#!/usr/bin/ruby
# -*- coding: utf-8 -*-

def is_package_installed (name)
  system("pacman -Qi " + name + " > /dev/null 2> /dev/null")
end

# open logfile:
logfile = ARGV[0]
log = File.new(logfile, "r")
fsize = File.size(logfile)
# read lines:
line = ""
packages = {}
(fsize-1).downto(0) {
  |p|
  log.seek(p, IO::SEEK_SET)
  c = log.getc.chr
  if c == "\n" or p == 0
    if p == 0
      line = c + line
    end
    if line != ""
      # get package name:
      name = line.split(':')[3]
      name.strip!
      name = name.split(' ')[0]
      if packages.keys.index(name) == nil
        # package name not in packages hash, so get date:
        date = line.split('(')[0]
        date.strip!
        # ... and state:
        state = line.split(')')[1].split(':')[0]
        state.strip!
        if state == 'DONE'
          state_ = 0
        elsif state == 'ARCH'
          state_ = 2
        else
          state_ = 1
        end
        packages[name] = [ state_, date ]
      end
      line = ""
    end
  else
    line = c + line
  end
}
puts "Last builds (" + String(packages.length) + " different packages):"
packages.each {
  |key, pkg|
  if pkg[0] == 0
    if is_package_installed(key)
      puts "  + SUCCESSFUL: " + pkg[1] + " " + key
    else
      puts "  ! SUCCESSFUL: " + pkg[1] + " " + key
    end
  elsif pkg[0] == 2
    if is_package_installed(key)
      puts "  ? ARCHFAIL:   " + pkg[1] + " " + key
    else
      puts "  - ARCHFAIL:   " + pkg[1] + " " + key
    end
  else
    if is_package_installed(key)
      puts "  ? FAILED:     " + pkg[1] + " " + key
    else
      puts "  - FAILED:     " + pkg[1] + " " + key
    end
  end
}
