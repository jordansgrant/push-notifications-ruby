# frozen_string_literal: true

require 'caze'
require 'forwardable'

module Pusher
  module PushNotifications
    module UseCases
      class DeleteUser
        include Caze
        extend Forwardable

        class UserDeletionError < RuntimeError; end

        export :delete_user, as: :delete_user

        def initialize(user:)
          @user = user
          @user_id = Pusher::PushNotifications::UserId.new

          raise UserDeletionError, 'User Id cannot be empty.' if user.empty?
          if user.length > max_user_id_length
            raise UserDeletionError, 'User id length too long ' \
            "(expected fewer than #{max_user_id_length + 1} characters)"
          end
        end

        # Contacts the Beams service
        # to remove all the devices of the given user.
        def delete_user
          client.delete("users/#{user}")
        end

        private

        attr_reader :user, :user_id
        def_delegators :@user_id, :max_user_id_length

        def client
          @client ||= PushNotifications::Client.new
        end
      end
    end
  end
end
