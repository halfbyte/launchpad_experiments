$:.unshift(File.dirname(__FILE__) + "/lib/")
require 'timer'
require 'rubygems'
require 'launchpad'
require 'sequencer'
require 'portmidi'

@interaction = Launchpad::Interaction.new
@interaction.device.reset
Portmidi.output_devices.each do |device|
  puts "%d> %s" % [device.device_id, device.name]
end
puts "Please input device num to open for output:"
dev_num = 6 #gets.to_i

@output = Portmidi::Output.new(dev_num)
@output.write_short(0xB2, 123, 0)
@seq = Sequencer.new
@timer = Timer.new(60 / (100.0 * 4.0)) do 
  begin
    8.times do |row|
      @interaction.device.change(:grid, :x => @seq.prev, :y => row, :red => 0, :green => @seq[@seq.prev, row])      
      @interaction.device.change(:grid, :x => @seq.col, :y => row, :red => :lo, :green => @seq[@seq.col, row])
      if @seq[@seq.prev, row] == 3
        @output.write_short(0x99, 36 + row, 0x00)
      end
      if @seq[@seq.col, row] == 3
        @output.write_short(0x99, 36 + row, 0x7F)
      end
    end
  rescue => e
    puts "sequencer"
    puts e
  ensure
    @seq.advance
  end
end


@interaction.response_to(:mixer, :up) do |interaction, action|
  puts "stoppit!"
  @timer.stop
  @interaction.stop
end

@interaction.response_to(:grid, :down) do |interaction, action|
  begin
    @seq[action[:x], action[:y]] = (@seq[action[:x], action[:y]] == 3) ? 0 : 3
    interaction.device.change(:grid, :x => action[:x], :y => action[:y], :red => 0, :green => @seq[action[:x], action[:y]])
  rescue => e
    puts "interaction"
    puts e
  end
end

@interaction.start

sleep 1