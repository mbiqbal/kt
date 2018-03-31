module Exceptions
  class AuthenticationError < StandardError; end
  class InvalidParams < StandardError; end
  class AuthorizationError < StandardError; end
end