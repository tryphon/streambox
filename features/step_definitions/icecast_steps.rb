Then /^Icecast should not respond on "([^\"]*)"$/ do |url|
  url = URI.parse(url)

  lambda {
    timeout(3) do
      TCPSocket.new(url.host, url.port).close
    end
  }.should raise_error
end
