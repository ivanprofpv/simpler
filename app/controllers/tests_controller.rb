class TestsController < Simpler::Controller

  def index
    @time = Time.now
    headers['Content-Type'] = 'text/plain'
    #render plain: "Plain text response"
    status 201
  end

  def create

  end

end
