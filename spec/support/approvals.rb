# frozen_string_literal: true

require 'approvals/rspec'

Approvals.configure do |c|
  c.approvals_path = 'spec/fixtures/approvals'
  c.excluded_json_keys = {
    object_id: /^id|account_id$/,
    time: /^created_time|updated_time|start_time$/,
    duration: /^age$/
  }
end
