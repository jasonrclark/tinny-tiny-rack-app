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

    content = content("start.html", name: name, greeting: greeting)

    status_code = 200
    headers = {}
    response = [content]

    [status_code, headers, response]
  end

  def content(file, locals)
    context = binding
    locals.each do |key, value|
      context.local_variable_set(key, value)
    end

    template = File.read(file)
    ERB.new(template).result(context)
  end
end

run Application.new
