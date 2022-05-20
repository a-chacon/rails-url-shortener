# frozen_string_literal: true

module RailsUrlShortener
  class Url < ApplicationRecord
    # variables
    attr_accessor :generating_retries, :key_length

    # relations
    belongs_to :owner, polymorphic: true, optional: true
    has_many :visits, dependent: :nullify

    # validations
    validates :key, presence: true, length: { minimum: RailsUrlShortener.minimum_key_length }, uniqueness: true
    validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

    # exclude records in which expiration time is set and expiration time is greater than current time
    scope :unexpired, -> { where(arel_table[:expires_at].eq(nil).or(arel_table[:expires_at].gt(::Time.current))) }

    after_initialize :set_attr
    # callbacks
    before_validation :generate_key

    ##
    # set default instance variables values
    def set_attr
      @generating_retries = 0
      @key_length = RailsUrlShortener.key_length
    end

    ##
    # create a url object with the given params
    #
    # if something is wrong return the object with errors

    def self.generate(url, owner: nil, key: nil, expires_at: nil, category: nil)
      create(
        url: url,
        owner: owner,
        key: key,
        expires_at: expires_at,
        category: category
      )
    end

    ##
    # find a Url object by the key param
    #
    # if the Url is not found an exception is raised
    ## TODO:  and pass query params
    def self.find_by_key!(key, request: nil)
      # Get the token if not exipired
      url = Url.unexpired.find_by!(key: key)
      Visit.parse_and_save(url, request) unless request.nil?
      url
    end

    ##
    # find a Url object by the key param
    #
    # if the Url is not found the exception is rescue and
    # return a new url object with the default url

    def self.find_by_key(key, request: nil)
      find_by_key!(key, request: request)
    rescue ActiveRecord::RecordNotFound
      Url.new(
        url: RailsUrlShortener.default_redirect || '/',
        key: 'none'
      )
    end

    private

    def key_candidate
      (0...key_length).map { RailsUrlShortener.charset[rand(RailsUrlShortener.charset.size)] }.join
    end

    def generate_key
      return unless key.nil?

      loop do
        # plus to the key length if after 10 attempts was not found a candidate
        self.key_length += 1 if generating_retries >= 10
        self.key = key_candidate
        self.generating_retries += 1
        break unless self.class.exists?(key: key)
      end
    end
  end
end
