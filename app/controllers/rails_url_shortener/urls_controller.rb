module RailsUrlShortener
  class UrlsController < ActionController::Metal
    include ActionController::StrongParameters
    include ActionController::Redirecting
    include ActionController::Instrumentation
    include Rails.application.routes.url_helpers

    def show
      # Find, if you pass the request then this is saved
      # or you can save this manually with the method model: Visit.parse_and_save(url, request)
      url = Url.find_by_key(params[:key], request: request)
      redirect_to url.url, status: :moved_permanently
    end
  end
end
