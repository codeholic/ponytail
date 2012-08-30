require 'erb'
class HomeAction < Cramp::Action
  def start
    template = ERB.new(File.read(Ponytail::Application.root('app/views/index.erb')))
    render template.result(binding)
    finish
  end
end
