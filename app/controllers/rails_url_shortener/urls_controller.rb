module RailsUrlShortener
  class UrlsController < ActionController::Metal
    include ActionController::StrongParameters
    include ActionController::Redirecting
    include ActionController::Instrumentation
    include Rails.application.routes.url_helpers

    def show
      # token = ::Shortener::ShortenedUrl.extract_token(params[:id])
      # track = Shortener.ignore_robots.blank? || request.human?
      # url   = ::Shortener::ShortenedUrl.fetch_with_token(token: token, additional_params: params, track: track)
      # Find
      url = Url.find_by_key(params[:key])
      # Save visit
      Visit.parse_and_save(request)
      redirect_to url.url, status: :moved_permanently
    end
  end
end
