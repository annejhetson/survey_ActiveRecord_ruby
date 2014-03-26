require 'active_record'
require 'rspec'
require 'shoulda-matchers'

require 'survey'
require 'question'
require 'answer'



ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Survey.all.each { |survey| survey.destroy }
    Answer.all.each { |answer| answer.destroy }
  end

end
