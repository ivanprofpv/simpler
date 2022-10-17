require_relative 'view'

module Simpler
  class Controller

    HTTP_CODE_STATUS = {
      '200' => 'OK',
      '201' => 'Created',
      '400' => 'Bad Request',
      '403' => 'Forbidden',
      '404' => 'Not Found',
      '429' => 'Resource',
      '500' => 'Internal Server Error',
      '503' => 'Service Unavailable',
      '504' => 'Gateway Timeout'
    }.freeze

    attr_reader :name, :request, :response

    def initialize(env, logger)
      @logger = logger
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      build_params(env)
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      logger_info
      @response.finish
    end

    private

    def build_params(env)
      array = env['REQUEST_PATH'].split("/")
      @request.params[:id] = array[2].to_i if array[2].to_i && array[2].to_i != 0
      @logger.info("Parameters: " + @request.params.to_s)
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def status
      @response.status = status
    end

    def headers
      @response
    end

    def logger_info
      @logger.info("Response: " +
        @response.status.to_s + " " +
        HTTP_CODE_STATUS[@response.status.to_s].to_s + " " +
        @response['Content-Type'].to_s + " " +
        @request.env['simpler.template_path'].to_s
      )
    end

  end
end
