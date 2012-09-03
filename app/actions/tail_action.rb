require 'eventmachine-tail'
require 'json'

class TailAction < Cramp::Action
  self.transport = :sse

  on_start :subscribe
  on_finish :unsubscribe

  @@channel = EventMachine::Channel.new
  @@filetail = EventMachine::file_tail('/tmp/ponytail') do |filetail, line|
    @@channel.push line
  end

  def subscribe
    @sid = @@channel.subscribe do |message|
      render( { data: message }.to_json )
    end
  end

  def unsubscribe
    @@channel.unsubscribe(@sid) if @sid
  end

  def respond_with
    [200, {'Content-Type' => 'text/javascript'}]
  end
end
