class JancodeController < ApplicationController
    def jancodeSearch
        jancode = params[:jancode]
        
        response = Product.find_by(jancode: jancode)
        if response
            render json: response
        else
            render json: { error: "商品が見つかりません" }, status: :not_found
        end
        render json: response
    end
end
