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


    # @param [String] username
    # == Example of a repo data can be found on http://developer.github.com/v3/repos/
    # @return [Array] Array of repos
    def get_user_repos(username)
      github_api.repos.list(user: username).body
    end

    def get_user_orgs(username)
      github_api.orgs.list(user: username).body
    end

    # This method returns all files committed by given username in a repo.
    # @param [String] username
    # @param [String] repo_name

    # @param [String] repo_owner # use this if its an organization repo
    # == Example:
    #   get_user_files_from_repo('beydogan', 'github_data_parser', 'kodgemisi')
    # The code above will return all commited files in repo 'kodgemisi/github_data_parser' by user 'beydogan'

    # Example element(file) of array
    #{
    #    "sha" => "a8647326344e1eda55404639ddfc5fc33782e0e6",
    #    "filename" => "README.md",
    #    "status" => "modified",
    #    "additions" => 8,
    #    "deletions" => 0,
    #    "changes" => 8,
    #    "blob_url" => "https://github.com/beydogan/github-commit-analyzer/blob/a8f75e95cf1c9e20dcb9172b93d59248d0fb1e32/README.md",
    #    "raw_url" => "https://github.com/beydogan/github-commit-analyzer/raw/a8f75e95cf1c9e20dcb9172b93d59248d0fb1e32/README.md",
    #    "contents_url" => "https://api.github.com/repos/beydogan/github-commit-analyzer/contents/README.md?ref=a8f75e95cf1c9e20dcb9172b93d59248d0fb1e32",
    #    "patch" => "@@ -2,3 +2,11 @@ github-commit-analyzer\n ======================\n \n Simple console application which analyze a github user's commits and outputs number of the committed files by file type.\n+\n+Usage\n+======================\n+\n+```\n+bundle install\n+ruby main.rb\n+```"
    #}
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

    # This method returns all files committed by given username in given repos
    # @param [String] username
    # @param [Array] repo_list
    # == Example
    #   gdp = GithubDataParser.new (.....)
    #   user_repos = gdp.get_user_repos('beydogan')
    #   user_files = get_user_files_from_repos('beydogan', repo_list)
    # @return [Array] Array of files
    def get_user_files_from_repos(username, repo_list)
      repo_list.each do |repo|
        name = repo.name
        owner = repo.owner.login
        files = get_user_files_from_repo(username, name, owner)
        all_points.merge!(analyze_files(files))
      end
    end






  end
end
