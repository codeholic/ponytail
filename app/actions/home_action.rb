require 'eventmachine-tail'

class HomeAction < Cramp::Action
  self.transport = :long_polling

  on_start :setup_timeout
  on_start :subscribe

  on_finish :unsubscribe

  @@channel = EventMachine::Channel.new
  @@filetail = EventMachine::file_tail('/tmp/ponytail') do |filetail, line|
    @@channel.push line
  end

  def setup_timeout
    @timer = EventMachine::Timer.new(10) do
      render 'timeout'
    end
  end

  def subscribe
    @sid = @@channel.subscribe do |message|
      @timer.cancel
      render message
    end
  end

  def unsubscribe
    @@channel.unsubscribe(@sid) if @sid
  end

  def respond_with
    [200, {'Content-Type' => 'text/plain'}]
  end
end
