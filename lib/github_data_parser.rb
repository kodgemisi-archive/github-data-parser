require "github_data_parser/version"
require "github_data_parser/configuration"
require 'github_api'

module GithubDataParser
  extend Configuration

  class << self

    attr_accessor :client_id,

    def new(options = {}, &block)
      Github::Client.new(options, &block)
    end

  end
end
