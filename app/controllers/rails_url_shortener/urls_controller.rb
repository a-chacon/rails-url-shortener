module RailsUrlShortener
  class UrlsController < ActionController::Metal
    include ActionController::StrongParameters
    include ActionController::Redirecting
    include ActionController::Instrumentation
    include Rails.application.routes.url_helpers

    def show
      # Find
      url = Url.find_by_key(params[:key])
      # Save visit
      Visit.create(url: url, meta: request)
      redirect_to url.url, status: :moved_permanently
    end
  end
end
