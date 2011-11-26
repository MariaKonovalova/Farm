# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Farm::Application.initialize!

=begin
Farm::Application.configure do
  config.active_record.schema_format = :sql
end
=end
