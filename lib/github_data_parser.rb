require "github_data_parser/version"
require 'github_api'

module GithubDataParser

  class << self

    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :github_api

    def new(options = {})
      self.client_id = options[:client_id]
      self.client_secret = options[:client_secret]

      self.github_api = Github.new do |config|
        config.client_id = self.client_id
        config.client_secret = self.client_secret
        config.per_page = 100
      end


      puts github_api.repos.list user: 'beydogan'

    end

  end
end
