module SpaceApi
  module Helpers

    def json_response(code, response)
      cross_origin
      content_type :json
      status code
      response[:status] = code
      if prettify?
        return JSON.pretty_generate response
      else
        return response.to_json
      end
    end

    # Handle application errors.
    def error_response(error_type = nil)
      case error_type
        when :user_parameters_error, :user_authentication_error
          json_response 401, { error: 'Unauthorized' }
        when :not_found_error
          json_response 404, { error: 'Not Found' }
        when :internal_server_error
          json_response 500, { error: 'Internal Server Error' }
        else # :unknown_error
          json_response 400, { error: 'Bad Request' }
      end
    end

    def log(arg, method = 'info')
      logger.send(method, arg)
    end

    def accept_params(params, *fields)
      h = {}
      fields.each do |name|
        h[name] = params[name] if params[name]
      end
      h
    end

    def prettify?
      not(!params[:pretty].nil? && params[:pretty] == 'false')
    end

    def scientific_notation(str)
      res = str.split(':')
      res.shift
      res = res.join('').split('x').map(&:strip)
      res[-1] = res.last[2..-1]
      res = res.map(&:to_f)
      res = res.first * (10 ** res.last)
      res
    end

  end
end
