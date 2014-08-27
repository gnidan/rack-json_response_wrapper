module Rack
  class JsonResponseWrapper
    def initialize(app)
      @app = app
    end

    def call(env)
      response = @app.call(env)

      if should_wrap? env, response
        wrap_response(response)
      else
        response
      end
    end

    private

    def should_wrap?(env, response)
      response_header = response[1]

      is_json = response_header['Content-Type'].match(/application\/json/)
      wants_wrap = env.include?('HTTP_X_WRAP_RESPONSE') ||
                   env.include?('X-WRAP-RESPONSE')

      is_json && wants_wrap
    end

    def wrap_response(response)
      response_header = response[1]

      response_body = ''
      response[2].each do |segment|
        response_body += segment
      end

      response_obj = JSON.parse(response_body)

      wrapped_obj = {
        header: response_header,
        body: response_obj
      }

      # dump JSON to get new content length
      wrapped_body = JSON.dump(wrapped_obj)

      # when we change the content-length, the length will change.
      # therefore, calculate the offset by comparing the length of the old vs. new
      original_content_length = response_header['Content-Length']
      new_content_length = wrapped_body.length
      adjusted_content_length =
        new_content_length.to_s.to_json.length - original_content_length.to_s.to_json.length

      # adjust the new content-length by this offset
      new_content_length += adjusted_content_length

      # set the content length part of the header and redump the JSON
      wrapped_obj[:header]['Content-Length'] = new_content_length.to_s
      wrapped_body = JSON.dump(wrapped_obj)

      wrapped = response.dup
      wrapped[2] = [wrapped_body]

      wrapped
    end
  end
end
