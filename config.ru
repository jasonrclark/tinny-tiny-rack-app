class Application
  def call(env)
    status_code = 200
    headers = {}
    response = ["Hello World!"]

    [status_code, headers, response]
  end
end

run Application.new
