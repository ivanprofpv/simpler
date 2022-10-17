require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(bind)
      plain = check_plain_template
      return plain unless plain.nil?
      template = File.read(template_path)

      ERB.new(template).result(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def check_plain_template
      @template = template
      if @template.class == Hash
        @template[:plain] + "\n" if @template[:plain]
      end
    end

    def template_path
      path = @template || [controller.name, action].join('/')
      @env['simpler.template_path'] = "#{path}.html.erb"
      template_path = Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
