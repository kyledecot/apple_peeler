# frozen_string_literal: true

require 'ferrum'

class ApplePeeler
  class Documentation
    class Pool
      attr_reader :jobs

      def initialize(size:)
        @size = size
        @jobs = Queue.new
        @browser = Ferrum::Browser.new(:headless => false)

        @pool = Array.new(@size) do |i|
          Thread.new(@browser.contexts.default_context) do |context| 
            Thread.current[:id] = i
            Thread.stop
            
            page = context.create_page

            catch(:exit) do
              loop do
                job, *args = @jobs.pop
                job.call(page, *args)
              end
            end
          end
        end
      end

      def open(&block)
        @pool.map(&:wakeup)
        
        block.call

        loop do 
          sleep(5)

          break if @jobs.empty?
        end 
      end 

      def schedule(*args, &block)
        @jobs << [block, *args]
      end

      def shutdown
        @size.times do
          schedule(nil) { throw :exit }
        end

        @pool.map(&:join) 

        @browser.quit

        true
      end
    end
  end
end
