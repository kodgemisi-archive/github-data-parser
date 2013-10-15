module GithubDataParser

  module Configuration
    VALID_OPTIONS_KEYS = [
        :client_id,
        :client_secret
    ]

    attr_accessor *VALID_OPTIONS_KEYS

  end
end
