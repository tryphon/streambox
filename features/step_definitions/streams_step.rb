class StreamNoDownload < StandardError; end

def stream_content_type(url)
  content_type = nil
  Net::HTTP.start(url.host, url.port) do |http|
    begin
      http.request_get(url.path) do |response|
        content_type = response['content-type']
        raise StreamNoDownload
      end
    rescue StreamNoDownload => e
      #
    end
  end
  content_type
rescue Exception => e
  nil
end

Then /^an? ([^ ]*) stream should respond on "([^\"]*)"$/ do |type, url|
  expected_content_type = {
    "ogg" =>  "application/ogg",
    "mp3" => "audio/mpeg",
    "aac" => "audio/aacp",
  }[type]

  content_type = stream_content_type(URI.parse(url))
  retry_count = 3
  while retry_count > 0 and (content_type.nil? or content_type == "text/html")
    retry_count -= 1
    sleep 3
    content_type = stream_content_type(URI.parse(url))
  end

  expect(content_type).to eq(expected_content_type)
end
