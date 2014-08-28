rack-json_response_wrapper
==========================

Rack Middleware for JSON APIs accessed cross-domain from legacy browsers

Firefox versions <4 does not support response headers for cross-domain requests. This middleware intercepts all requests and if the X-WRAP-RESPONSE is set, the response will be wrappped in JSON as follows:

Suppose the following is the original response body:

    {"key": "value"}
    
With X-WRAP-RESPONSE set to true, the new response will be:

    {
      "header": { ... bunch of headers ... },
      "body": {"key": "value"}
    }
