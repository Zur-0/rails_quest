class Quest3AccessGateController < ApplicationController
  # TODO: Add routes in config/routes.rb and finish the controller logic for Quest 3.
  # The quest expects a mix of GET / POST / PATCH / DELETE, conditional redirects,
  # and visible before_action / after_action callbacks.

  # Quest3DataService probes POST/PATCH/DELETE actions without a browser CSRF token.
  # Disable CSRF verification here so the probe can validate route/controller logic.
  skip_forgery_protection


  # Register callbacks here.
 before_action :prepare_clearance_total, only: [:clearance]
  before_action :extract_token, only: [:granted]
  after_action :set_clearance_trace, only: [:clearance]
  after_action :set_token_checked_trace, only: [:granted]

  def ping
    render plain: "ACCESSGATE PING OK", status: :ok
  end

  def scan
    render plain: "SCAN RESULT: #{params[:agent]} -> sector #{params[:sector]}", status: :ok
  end

  def power
    total = params[:current].to_i + params[:boost].to_i
    render plain: "POWER TOTAL: #{total}", status: :ok
  end

  def stale_logs
    render plain: "STALE LOGS CLEARED: #{params[:count]}", status: :ok
  end

  def clearance
    render plain: "CLEARANCE TOTAL: #{@clearance_total}", status: :ok
  end

def verify
  token = params[:token]

  if token.start_with?("alpha")
    redirect_to "/access_gate/granted?token=#{token}"
  else
    redirect_to "/access_gate/denied?token=#{token}"
  end
end


  def granted
    render plain: "TOKEN ACCEPTED: #{@token}", status: :ok
  end

  def denied
    render plain: ""
  end

  private

  def prepare_clearance_total
    @clearance_total = params[:level].to_i + params[:boost].to_i
  end

  def set_clearance_trace
    response.headers["X-Access-Gate-Trace"] = "CLEAREANCE_GRANTED"
  end

  def extract_token
    @token = params[:token]
  end

  def set_token_checked_trace
    response.headers["X-Access-Gate-Trace"] = "token_checked"
  end
  # Implement callbacks here
  # response.set_header("X-Access-Gate-Trace", "") may be helpful
end
