class Application
  def call(env)
    request = Rack::Request.new(env)
    name = request.params["name"] || "World"

    status_code = 200
    headers = {}
    response = ["Hello #{name}!"]

    [status_code, headers, response]
  end
end

run Application.new
