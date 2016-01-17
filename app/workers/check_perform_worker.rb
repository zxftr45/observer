class CheckPerformWorker
  include Sidekiq::Worker

  def perform(id)
    @check = Check.find(id)
    @old_state = @check.is_ok
    check_http
    save_data
    check_result
  end

  private

  def save_data
    @check.results << Result.new(is_ok: @result, timeout: @response_time, response: @response)
  end

  def check_http
    3.times.any? { |_x| respond_to_http? }
    @check.update(is_ok: @result)
  end

  def check_result
    if @old_state && !@check.is_ok
      send_failure_emails
    elsif !@old_state && @check.is_ok
      send_successful_emails
    end
  end

  def respond_to_http?
    start_time = Time.now
    request = HTTP.get(@check.url)
    @response_time = (Time.now - start_time) * 1000
    @result = request.status < 400
    @response = request.body
    sleep(10) unless @result
    @result
  rescue Errno::ECONNREFUSED, Errno::ENETDOWN, SocketError, IOError, URI::InvalidURIError
    @result = false
    @response_time = nil
    sleep(10)
    @result
  end

  def send_failure_emails
    MailerService.new.send_host_failed_email(@check)
  end

  def send_successful_emails
    MailerService.new.send_host_success_email(@check)
  end
end
