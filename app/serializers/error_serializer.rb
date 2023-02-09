class ErrorSerializer

  def initialize(exception = {})
    @exception = exception
  end

  def serialize
    {
      "message": "#{@exception.message}",
      "errors": []
    }
  end
end
