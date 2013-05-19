require 'vmbox'

After do
  VMBox.new("streambox").rollback
end
