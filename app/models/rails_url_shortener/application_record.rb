# frozen_string_literal: true

module RailsUrlShortener
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
