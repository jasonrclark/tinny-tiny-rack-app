require 'erb'

class Application
  def call(env)
    request = Rack::Request.new(env)
    name = request.params["name"] || "World"

    if request.get?
      if request.path == "/farewell"
        greeting = "Goodbye"
      elsif request.path == "/"
        greeting = "Hello"
      else
        return [404, {}, ["What's that? Don't know that address."]]
      end
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

class DebuggingMiddleware
  def initialize(app, *_)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    status_code, headers, response = @app.call(env)

    if request.params["debug"]
      response.map! { |r| r.gsub("</html>", "#{request.params}</html>") }
    end

    [status_code, headers, response]
  end
end

use DebuggingMiddleware
run Application.new
