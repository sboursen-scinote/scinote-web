# frozen_string_literal: true

module Api
  module V1
    class RepositoryLedgerRecordSerializer < ActiveModel::Serializer
      attributes :amount, :balance, :comment, :unit

    end
  end
end
