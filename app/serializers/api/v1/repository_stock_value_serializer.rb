# frozen_string_literal: true

module Api
  module V1
    class RepositoryStockValueSerializer < ActiveModel::Serializer
      attribute :repository_stock_unit_item_id, key: :inventory_stock_unit_item_id
      attributes :amount, :low_stock_threshold, :comment

      has_many :repository_ledger_records, key: :inventory_ledger_records,
                                           serializer: RepositoryLedgerRecordSerializer,
                                           class_name: 'RepositoryLedgerRecord'

      include TimestampableModel
    end
  end
end
