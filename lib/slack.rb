require 'net/http'
class Slack

  def initialize(config, build_label)
    @config = config
    @build_label = build_label
  end

  def send(message)
    t = @config['wraith_daemon']['notifications']['types'];
    x = t.find { |h| h['slack'] }
    if x==nil
      return
    end


    uri = URI.parse(x['slack']['url'])
    payload = {:text => message, :username => 'wraith', :unfurl_links => true}

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.path+'?'+uri.query)
    request.add_field('Content-Type', 'application/json')
    request.body = JSON.generate(payload)
    http.request(request)

  end
end
