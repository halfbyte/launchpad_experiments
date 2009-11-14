#!/usr/bin/env ruby
require 'rubygems'
require 'chars'
require 'launchpad'

include Portmidi

device = Launchpad::Device.new(:input => false, :output => true)

text = "hallo welt  "

loop do
  text.each_char do |char|
    device.reset
    Chars.write_by_pixel(char) do |x,y|
      device.change :grid, :x => x, :y => y, :red => :hi, :green => 0
    end
    sleep 0.2
  end
end