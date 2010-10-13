
class MessageAPI < ActionWebService::API::Base
  # api_method :create, :expects => [Api::Token, :string], :returns => [:boolean]
  api_method :show, :expects => [Api::Token, :int], :returns => [Api::Message]
  api_method :index, :expects => [Api::Token], :returns => [[Api::Message]]

  api_method :index_expired_unread, :expects => [Api::Token], :returns => [[Api::Message]]
  api_method :index_cancelled_unread, :expects => [Api::Token], :returns => [[Api::Message]]
  api_method :index_unexpired_unread, :expects => [Api::Token], :returns => [[Api::Message]]
  api_method :index_by_roles, :expects => [Api::Token], :returns => [[Api::Message]]

  api_method :update, :expects => [Api::Token, Api::Message], :returns => [Api::Message]

  api_method :index_inbox, :expects => [Api::Token], :returns => [[Api::Message]]
  api_method :index_outbox, :expects => [Api::Token], :returns => [[Api::Message]]
  api_method :index_read, :expects => [Api::Token], :returns => [[Api::Message]]
  api_method :index_unread, :expects => [Api::Token], :returns => [[Api::Message]]
  api_method :delete, :expects => [Api::Token, Api::Message], :returns => [Api::Message]
  api_method :deliver, :expects => [Api::Token, Api::Message], :returns => [Api::Message]
  api_method :reply, :expects => [Api::Token, Api::Message, Api::Step], :returns => [Api::Message]
  api_method :deliver_message_after_init_transaction, :expects => [Api::Token, Api::Step, :string, :string], :returns => [Api::Message]
end