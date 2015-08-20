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

    render :start, name: name, greeting: greeting
  end

  def content(file, locals)
    context = binding
    locals.each do |key, value|
      context.local_variable_set(key, value)
    end

    template = File.read(file)
    ERB.new(template).result(context)
  end

  def render(name, locals)
    content = content("#{name}.html", locals)

    status_code = 200
    headers = {}
    response = [content]

    [status_code, headers, response]
  end
end

class SimpleMiddleware
  def initialize(app, *_)
    @app = app
  end

  def call(env)
    puts "Hi there!"
    @app.call(env)
  end
end

use SimpleMiddleware

run Application.new
