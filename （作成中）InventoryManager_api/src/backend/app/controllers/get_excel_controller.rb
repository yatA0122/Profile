class GetExcelController < ApplicationController
    require 'caxlsx'
  
    def export_excel
      Axlsx::Package.new do |p|
        # 新しいワークシートを作成
        p.workbook.add_worksheet(name: "Product List") do |sheet|
          # ヘッダー行を作成
          sheet.add_row ["品名", "単価", "発注数", "申込番号"]
  
          # データを1行ずつ追加
          Product.all.each do |product|
            difference = product.standard_stock_quantity - product.stock_quantity
            if difference >= 1
              sheet.add_row [
                product.name, 
                product.price,
                difference,
                product.product_code
              ]
  end
          end
        end
  
        # ファイルをバイトストリームとして出力
        send_data p.to_stream.read,
                  filename: "products_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx",
                  type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      end
    end
  end