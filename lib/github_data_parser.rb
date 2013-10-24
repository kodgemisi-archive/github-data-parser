require "github_data_parser/version"
require 'octokit'

module GithubDataParser

  class << self

    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :github_api

    def new(options = {})
      self.client_id = options[:client_id]
      self.client_secret = options[:client_secret]

      self.github_api = Octokit::Client.new({
          :client_id => self.client_id,
          :client_secret => self.client_secret,
          :auto_paginate => true,
          :per_page => 100
          })

      return self
    end

    # This method returns all repos of username
    # @param [String] username
    # == Example of a repo data can be found on http://developer.github.com/v3/repos/
    # @return [Array] Array of repos
    def get_user_repos(username)
      puts username
      user = github_api.user username
      github_api.get(user.rels[:repos].href)
    end

    # This method returns all list of organizations that username member of it
    # @param [String] username
    # == Example of a repo data can be found on http://developer.github.com/v3/repos/
    # @return [Array] Array of organizations
    def get_user_orgs(username)
      user = github_api.user username
      github_api.get(user.rels[:organizations].href)
    end


    def get_org_repos(org_name)
      github_api.organization_repositories(org_name)
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
      commits = github_api.commits({:owner => repo_owner, :name => repo_name}, nil, {:author => username})

      commits.each_with_index do |commit, index|

        commit_details = github_api.get github_api.commit({:owner => repo_owner, :name => repo_name}, commit.sha).rels[:self].href #Get commit details
        files = commit_details.files #Get committed files
        user_files.concat(files) #Add files to results

        sleep(0.2) if(index % 20 == 0)
      end

      user_files
    end


    def get_user_commits(username, repo_name, repo_owner = nil)
      "Im getting commits!!!!"
      repo_owner = username if repo_owner.nil?

      github_api.commits({:owner => repo_owner, :name => repo_name}, nil, {:author => username})
    end


    def get_commit(commit_sha, repo, repo_owner)
      commit_details = github_api.get github_api.commit({:owner => repo_owner, :name => repo}, commit_sha).rels[:self].href #Get commit details
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

      puts "Total Number of Repos: "  + repo_list.size.to_s

      result = []
      repo_list.each do |repo|
        puts "Started: " + repo.name + "\n"
        name = repo.name
        owner = repo.owner.login
        files = get_user_files_from_repo(username, name, owner)
        result = result.concat(files)

        puts "Finished: " + repo.name + "\n"

      end
      result
    end
  end
end
