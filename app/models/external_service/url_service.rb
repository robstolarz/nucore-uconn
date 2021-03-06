#
# A UrlService is an +ExternalService+ that is
# accessed via HTTP/URLs.
class UrlService < ExternalService

  include Rails.application.routes.url_helpers

  #
  # Provides a URL for entering new data at this +ExternalService+
  # [_receiver_]
  #   Is the receiver of a polymorphic +ExternalServiceReceiver+
  #   relationship. Useful for providing pass-thru HTTP param data
  #   to the external service.
  def new_url(receiver, request = nil)
    "#{location}?#{query_string(receiver, request)}"
  end

  def edit_url(receiver, request)
    "#{receiver.edit_url}?#{query_string(receiver, request)}"
  end

  def query_string(receiver, request)
    query = {
      success_url: success_path(receiver, request),
      referer: referer_url(request),
      receiver_id: receiver.id,
    }

    query[:order_number] = receiver.order_number if receiver.respond_to?(:order_number)
    query[:quantity] = receiver.quantity if receiver.respond_to?(:quantity)
    query.to_query
  end

  private

  def referer_url(request)
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}" if request
  end

  def success_path(receiver, request)
    params = {
      facility_id: receiver.product.facility.url_name,
      service_id: receiver.product.url_name,
      external_service_id: id,
      receiver_id: receiver.id,
    }
    params.merge!(host: request.host, port: request.port, protocol: request.protocol) if request
    complete_survey_url(params)
  end

end
