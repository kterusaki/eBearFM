require 'test_helper'

class MainsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "youtube client" do
  	request = Typhoeus::Request.new("https://accounts.google.com/o/oauth2/token",
										method: :post,
										headers: { 'Content-Type' => "application/x-www-form-urlencoded" },
										body: { client_id: ENV['GOOGLE_CLIENT_ID'],
								    				client_secret: ENV['GOOGLE_CLIENT_SECRET'],
														refresh_token: "1/vrJ9PBr-u8sJqFvtFh3AhDv_je-3ux-odAEnj3DEUfQ",
														grant_type: "refresh_token" })

  	request.run

  	response_body = JSON.parse(request.response.response_body)

  	binding.pry

  	access_token = response_body[:access_token]

  	p_request = Typhoeus::Request.new("https://")

  	puts response_body
  end
end
