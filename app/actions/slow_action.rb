class SlowAction < Cramp::Action
  before_start :sleep
  on_start :report

  def sleep
    operation = proc { Kernel.sleep params[:time].to_i }
    callback = proc do |result|
      if result == 0
        yield
      else
        halt 403, { 'Content-Type' => 'text/plain' }, 'Do not disturb'
      end
    end
    EventMachine.defer operation, callback
  end

  def respond_with
    [200, { 'Content-Type' => 'text/plain' }]
  end

  def report
    render 'On duty'
    finish
  end
end
