require 'monitor'

class Timer
   def initialize(interval, &handler)
     raise ArgumentError, "Illegal interval" if interval < 0
     extend MonitorMixin
     @run = true
     @th = Thread.new do
       t = Time.now
       while run?
  t += interval
  (sleep(t - Time.now) rescue nil) and
    handler.call rescue nil
       end
     end
   end

   def stop
     synchronize do
       @run = false
     end
     @th.join
   end

   private

   def run?
     synchronize do
       @run
     end
   end
end