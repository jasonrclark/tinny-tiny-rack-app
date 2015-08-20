require 'erb'

class Application
  def call(env)
    request = Rack::Request.new(env)
    goodbye = Proc.new { |request| render :start, name: name(request), greeting: "Goodbye" }
    hello   = Proc.new { |request| render :start, name: name(request), greeting: "Hello" }
    greet   = Proc.new { |request| render :start, name: name(request), greeting: user_greeting(request) }
    missing = Proc.new { |request| [404, {}, ["What's that? Don't know that address."]] }

    if request.get?
      if request.path == "/farewell"
        return goodbye.call(request)
      elsif request.path == "/"
        return hello.call(request)
      end
    elsif request.post?
      return greet.call(request)
    end

    return missing.call(request)
  end

  def name(request)
    request.params["name"] || "World"
  end

  def user_greeting(request)
    request.params["greeting"]
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
