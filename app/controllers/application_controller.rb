require 'net/http'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  RECAPTCHA_PRIVATE_KEY = '6Lce9MESAAAAANB_i2vW-9IzXOqSi07741wCuRSj';
    #try and verify the captcha response. Then give out a message to flash
    def verify_recaptcha(remote_ip, params)
	 
      responce = Net::HTTP.post_form(URI.parse('http://www.google.com/recaptcha/api/verify'),
	                                    {'privatekey'=>RECAPTCHA_PRIVATE_KEY, 'remoteip'=>remote_ip, 'challenge'=>params[:recaptcha_challenge_field], 'response'=> params[:recaptcha_response_field]})
      result = {:status => responce.body.split("\n")[0], :error_code => responce.body.split("\n")[1]}
	 
      if result[:error_code] == "incorrect-captcha-sol"
        flash[:alert] = "The CAPTCHA solution was incorrect. Please re-try"
      elsif result[:error_code] != "success"
        flash[:alert] = "There has been a unexpected error with the application. Please contact the administrator. error code: #{result[:error_code]}"
      end
	 
      result
   end
end