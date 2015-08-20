require 'erb'

require_relative 'base'
require_relative 'debugging_middleware'

class Application < Base
  get "/" do |request|
    render :start, name: name(request), greeting: "Hello"
  end

  get "/farewell" do |request|
    render :start, name: name(request), greeting: "Goodbye"
  end

  post "/" do |request|
    render :start, name: name(request), greeting: user_greeting(request)
  end

  post "/farewell" do |request|
    render :start, name: name(request), greeting: user_greeting(request)
  end

  def name(request)
    request.params["name"] || "World"
  end

  def user_greeting(request)
    request.params["greeting"]
  end
end

use DebuggingMiddleware
run Application.new
