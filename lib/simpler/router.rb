require_relative 'router/route'

module Simpler
  class Router

    def initialize
      @routes = []
    end

    def get(path, route_point)
      add_route(:get, path, route_point)
    end

    def post(path, route_point)
      add_route(:post, path, route_point)
    end

    def route_for(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = env['PATH_INFO']

      check_nested_route(method, path)
      find_route(method, path)
    end

    private

    def check_nested_route(method, path)
      path_for_matching = path.split("/")
      find_nested_route(method, path, path_for_matching) if path_for_matching[2].to_i
    end

    def find_nested_route(method, path, path_for_matching)
      controller = path_for_matching[1]
      path_for_matching[2] = ":id"
      path_for_matching = path_for_matching.join("/")
      nested_route = find_route(method, path_for_matching)
      create_nested_route(method, path, nested_route, controller) if nested_route
    end

    def create_nested_route(method, path, nested_route, controller)
      real_route = find_route(method, path)
      route_point = controller + "#" + nested_route.action
      add_route(method, path, route_point) unless real_route
    end

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      route = Route.new(method, path, controller, action)

      @routes.push(route)
    end

    def find_route(method, path)
      @routes.find do |route| 
        route.match?(method, path)
      end
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

  end
end
