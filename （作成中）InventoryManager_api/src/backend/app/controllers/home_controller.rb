class HomeController < ApplicationController
    def index
      render json: { message: "Hello, Rails API!", status: 200 }
    end
end