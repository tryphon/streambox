require 'vmbox'

def current_box
  @current_box = VMBox.new("streambox")
end

After do
  current_box.rollback
end
