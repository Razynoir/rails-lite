require 'webrick'
require 'json'

require_relative '../lib/controller_base'
require_relative '../lib/router.rb'

Dir["../app/controller/*.rb"].each { |file| require file }

server = WEBrick::HTTPServer.new(Port: 3000)

class CatsController < RailsLite::ControllerBase

  def index
    render :index
  end

  def show
    render :show
  end

end

class MyRouterClass < RailsLite::Router
  extendable_actions :patch
end

server.mount_proc("/") do |req, res|
  router = MyRouterClass.new
  router.draw do
    get Regexp.new("^/cats$"), CatsController, :index
    get Regexp.new("^/cats/(?<cat_id>\\d+)"), CatsController, :show
  end
  router.run(req, res)

  # render the controller params.
  # controller = CatsController.new(req, res)
  # res.body = "#{controller.params}"

  # Rendering the request line of the requeset.
  # req_line = req.request_line
  # controller.render_content(req_line, "text/text")

  # Parising the request body.
  # re = /^([^ ]+) ([^ ]+) ([^ ]+)$/
  # res.body = "#{re.match(req_line)[2]}"
end


trap("INT") { server.shutdown }
server.start
