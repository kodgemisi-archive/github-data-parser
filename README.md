github-data-parser
==================

Parses the repositeries, commits, issues of an user from github api


Usage
==================

```ruby

require 'github_data_parser'

gdp = GithubDataParser.new({
    :client_id => "CLIENT_ID",
    :client_secret => "CLIENT_SECRET",
     })

repos = gdp.get_user_repos('USERNAME')

repos.each do |repo|
  puts repo.full_name
end


```
