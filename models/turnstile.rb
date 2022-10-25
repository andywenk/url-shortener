class Turnstile
  attr_reader :cf_response, :cf_ip

  def initialize(options)
    @cf_response = options.fetch(:cf_response)
    @cf_ip = options.fetch(:cf_ip)
  end

  def check
    res = Net::HTTP.post_form siteverify_uri, uri_params
    JSON.parse(res.body)['success']
  end

  private 

  def siteverify_uri
    URI("https://challenges.cloudflare.com/turnstile/v0/siteverify")
  end

  def uri_params
    { 
      secret: ENV['TRUNSTILE_SECRET'],
      response: cf_response,
      remoteip: cf_ip 
    }
  end
end
