Gem::Specification.new do |s|
  s.name              = "rack-json_response_wrapper"
  s.version           = "0.1.2"
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Rack Middleware for JSON APIs accessed cross-domain from legacy browsers"
  s.homepage          = "http://github.com/gnidan/rack-json_response_wrapper"
  s.email             = "nick@gnidan.org"
  s.authors           = [ "g. nicholas d'andrea" ]
  s.has_rdoc          = false
  s.licenses          = ['Unlicense / Public Domain']

  s.files             = %w( README.md Rakefile LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("spec/**/*")

#  s.executables       = %w( rack-json_response_wrapper )
  s.description       = <<desc
Rack Middleware for JSON APIs accessed cross-domain from legacy browsers

Firefox version 4 does not support response headers for cross-domain requests.
This middleware intercepts all requests and if the X-WRAP-RESPONSE is set, 
the response will be wrappped in JSON like {header: ..., body: ...}
desc

  s.add_development_dependency('rspec', ['3.0.0'])
  s.add_development_dependency('rack-test', ['0.6.2'])
  s.add_development_dependency('sinatra', ['1.4.5'])
end
