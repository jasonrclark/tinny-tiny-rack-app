require 'erb'

class Application
  ROUTES = {
    :missing => Proc.new { |*_| [404, {}, ["What's that? Don't know that address."]] }
  }

  def self.get(path, &block)
    ROUTES[["GET", path]] = block
  end

  def self.post(path, &block)
    ROUTES[["POST", path]] = block
  end

  get "/" do |app, request|
    app.render :start, name: app.name(request), greeting: "Hello"
  end

  get "/farewell" do |app, request|
    app.render :start, name: app.name(request), greeting: "Goodbye"
  end

  post "/" do |app, request|
    app.render :start, name: app.name(request), greeting: app.user_greeting(request)
  end

  post "/farewell" do |app, request|
    app.render :start, name: app.name(request), greeting: app.user_greeting(request)
  end

  def call(env)
    request = Rack::Request.new(env)

    route_lookup = [request.request_method, request.path]
    route = ROUTES[route_lookup]
    route ||= ROUTES[:missing]

    route.call(self, request)
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
