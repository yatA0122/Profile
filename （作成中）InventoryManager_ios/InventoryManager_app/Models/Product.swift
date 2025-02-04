import Foundation

public struct Product: Codable, Identifiable, CustomStringConvertible {
    public var id: Int
    public var name: String
    public var productCode: String
    public var janCode: String
    public var stockQuantity: Int
    public var standardStockQuantity: Int
    public var orderLocation: String
    public var price: Int
    public var workplaceID: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case productCode = "product_code"
        case janCode = "jan_code"
        case stockQuantity = "stock_quantity"
        case standardStockQuantity = "standard_stock_quantity"
        case orderLocation = "order_location"
        case price
        case workplaceID = "workplace_id"
    }

    public var description: String {
        """
        Product:
          ID: \(id)
          Name: \(name)
          Product Code: \(productCode)
          JAN Code: \(janCode)
          Stock Quantity: \(stockQuantity)
          Standard Stock Quantity: \(standardStockQuantity)
          Order Location: \(orderLocation)
          Price: \(price)
          WorkplaceID: \(workplaceID)
        """
    }
}
