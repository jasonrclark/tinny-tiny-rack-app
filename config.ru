require 'erb'

class Application
  def call(env)
    request = Rack::Request.new(env)
    name = request.params["name"] || "World"

    if request.get?
      greeting = "Hello"
    elsif request.post?
      greeting = request.params["greeting"]
    end

    template = File.read("start.html")
    content = ERB.new(template).result(binding)

    status_code = 200
    headers = {}
    response = [content]

    [status_code, headers, response]
  end
end

run Application.new
