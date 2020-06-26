# frozen_string_literal: true

class RepositoryTableStateUpdate < ActiveRecord::Migration[6.0]
  class TempStateModel < ApplicationRecord
    self.table_name = 'repository_table_states'
  end

  def up
    TempStateModel.find_each do |table_state|
      begin
        state = table_state.state
        order_state = state.dig('order', 0, 0)

        unless order_state
          order = state.dig('order', '0')
          state['order'] = [order]
          order_state = state.dig('order', 0, 0)
        end

        state['order'][0][0] = order_state.to_i + 2 if order_state.to_i > 5

        if state['columns'].class == Hash
          columns_array = []
          state['columns'].each{ |k, v| columns_array[k.to_i] = v}
          state['columns'] = columns_array
        end

        2.times do
          state['columns'].insert(6,
                                  'search' => {
                                    'regex' => false, 'smart' => true, 'search' => '', 'caseInsensitive' => true
                                  },
                                  'visible' => false)
        end
        state['ColReorder'] = state['ColReorder'].map { |i| i.to_i > 5 ? i.to_i + 2 : i.to_i } + [6, 7] if state['ColReorder']
        table_state.update(state: state)
      rescue
        next
      end
    end
  end
end

