class TestsController < Simpler::Controller

  def index
    @time = Time.now
    @tests = Test.all
    headers['Content-Type'] = 'text/plain'
    #render plain: "Plain text response"
    status 201
  end

  def create

  end

  def show
    @test = Test.find(params[:id])
  end

end
