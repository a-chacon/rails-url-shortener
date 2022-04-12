module RailsUrlShortener
  class Url < ApplicationRecord
    # variables
    attr_accessor :custom_key, :generating_retries, :key_length
    # relations
    belongs_to :owner, polymorphic: true, optional: true
    has_many :visits

    # validations
    validates :key, presence: true, length: { minimum: RailsUrlShortener.minimum_key_length }, uniqueness: true
    validates :url, presence: true, format: URI::regexp(%w[http https])

    # exclude records in which expiration time is set and expiration time is greater than current time
    scope :unexpired, -> { where(arel_table[:expires_at].eq(nil).or(arel_table[:expires_at].gt(::Time.current))) }

    # callbacks
    before_validation :generate_key
    after_initialize :set_attr

    ##
    # set default instance variables values
    def set_attr
      @generating_retries = 0
      @key_length = RailsUrlShortener.key_length
    end

    ##
    # create a url object with the given params
    #
    # if something is wrong raise and exception

    def self.generate(url, owner: nil, key: nil, expires_at: nil, category: nil)
      self.create(
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
      unless request.nil?
        Visit.parse_and_save(url, request)
      end
      url
    end

    ##
    # find a Url object by the key param
    #
    # if the Url is not found the exception is rescue and
    # return a new url object with the default url

    def self.find_by_key(key, request: nil)
      begin
        find_by_key!(key, request: request)
      rescue ActiveRecord::RecordNotFound
        return Url.new(
          url: RailsUrlShortener.default_redirect || "/",
          key: "none"
        )
      end
    end

    private
    def key_candidate
      (0...self.key_length).map{ RailsUrlShortener.charset[rand(RailsUrlShortener.charset.size)] }.join
    end

    def generate_key
      unless !self.key.nil?
        loop do
          # plus to the key length if after 10 attempts was not found a candidate
          if self.generating_retries >= 10
            self.key_length += 1
          end
          self.key = self.key_candidate
          self.generating_retries += 1
          break if !self.class.exists?(key: self.key)
        end
      end

    end

  end
end
