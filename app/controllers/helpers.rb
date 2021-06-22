# frozen_string_literal: true

module CheckHigh
  # Methods for controllers to mixin
  module SecureRequestHelpers
    class UnauthorizedRequestError < StandardError; end

    class NotFoundError < StandardError; end

    def secure_request?(routing)
      routing.scheme.casecmp(Api.config.SECURE_SCHEME).zero?
    end

    def authorization(headers)
      # puts headers['AUTHORIZATION']
      return nil unless headers['AUTHORIZATION']

      scheme, auth_token = headers['AUTHORIZATION'].split
      return nil unless scheme.match?(/^Bearer$/i)

      scoped_auth(auth_token)
    end

    def scoped_auth(auth_token)
      contents = AuthToken.contents(auth_token)
      account_data = contents['payload']['attributes']

      { account: Account.first(username: account_data['username']),
        scope: AuthScope.new(contents['scope']) }
    end
  end
end
