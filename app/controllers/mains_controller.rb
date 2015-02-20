class MainsController < ApplicationController
	respond_to :html, :json

	def home
		respond_to do |format|
			format.html

			# TODO: Add format for json
		end
	end
end
