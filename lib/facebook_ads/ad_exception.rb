# frozen_string_literal: true

module FacebookAds
  class AdException < StandardError
    attr_reader :code, :title, :message

    def initialize(code:, title:, message:)
      @code = code
      @title = title
      @message = message
    end
  end
end
