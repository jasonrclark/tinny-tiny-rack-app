class Base
  ROUTES = {
    :missing => Proc.new { |*_| [404, {}, ["What's that? Don't know that address."]] }
  }

  def self.get(path, &block)
    ROUTES[["GET", path]] = block
  end

  def self.post(path, &block)
    ROUTES[["POST", path]] = block
  end

  def call(env)
    request = Rack::Request.new(env)

    route_lookup = [request.request_method, request.path]
    route = ROUTES[route_lookup]
    route ||= ROUTES[:missing]

    self.instance_exec(request, &route)
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
