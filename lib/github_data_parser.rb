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

      return self
    end


    def get_user_repos(username)
      github_api.repos.list user: username
    end

    def get_user_orgs(username)
      github_api.orgs.list user: username
    end

    # This method returns all files commited in a repo by given username.
    # @param [String] username
    # @param [String] repo_name

    # @param [String] repo_owner # use this if its an organization repo
    # Example:
    #   get_user_files_from_repo('beydogan', 'github_data_parser', 'kodgemisi')
    # The code above will return all commited files in repo 'kodgemisi/github_data_parser' by user 'beydogan'

    # @return [Array] Array of files
    def get_user_files_from_repo(username, repo_name, repo_owner = nil)

      repo_owner = username if repo_owner.nil?

      user_files = []
      commits = github_api.repos.commits.list repo_owner, repo_name, :author => username #Get all commits

      commits.each do |commit|

        commit_details = github_api.repos.commits.get repo_owner, repo_name, commit.sha #Get commit details
        files = commit_details.body.files #Get committed files
        user_files.concat(files) #Add files to results
      end

      user_files
  end






  end
end
