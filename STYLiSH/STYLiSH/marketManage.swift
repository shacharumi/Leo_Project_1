import UIKit
// MARK dataStruct
struct CamelCase: Codable {
    struct Color: Codable {
        let code: String
        let name: String
    }
    
    struct Variant: Codable {
        let color_code: String
        let size: String
        let stock: Int
    }
    
    struct Product: Codable {
        let id: Int
        let category: String
        let title: String
        let description: String
        let price: Int
        let texture: String
        let wash: String
        let place: String
        let note: String
        let story: String
        let colors: [Color]
        let sizes: [String]
        let variants: [Variant]
        let main_image: String
        let images: [String]
    }
    
    struct ProductList: Codable {
        let title: String
        let products: [Product]
    }
    
    let data: [ProductList]
}

enum GHError: Error {
    case invalidURL
    case invalidData
}

protocol MarketManagerDelegate: AnyObject {
    func manager(_ manager: MarketManager, didGet marketingHots: CamelCase)
    func manager(_ manager: MarketManager, didFailWith error: Error)
}
// Mark catchurl
class MarketManager {
    weak var delegate: MarketManagerDelegate?
    
    func getMarketingHots() async throws -> CamelCase {
        let url = "https://api.appworks-school.tw/api/1.0/marketing/hots"
        guard let requestURL = URL(string: url) else {
            throw GHError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: requestURL)
        let decoder = JSONDecoder()
        let marketingHots = try decoder.decode(CamelCase.self, from: data)
        return marketingHots
    }
    
    func fetchMarketingHots() {
        Task {
            do {
                let marketingHots = try await getMarketingHots()
                delegate?.manager(self, didGet: marketingHots)
            } catch {
                delegate?.manager(self, didFailWith: error)
            }
        }
    }
}
