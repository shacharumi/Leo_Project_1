import Foundation

// MARK: - PageJson
struct PageJson: Codable {
    let pageData: [Datum]
    let nextPaging: Int?

    enum CodingKeys: String, CodingKey {
        case pageData = "data"
        case nextPaging = "next_paging"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pageData = try container.decode([Datum].self, forKey: .pageData)
        nextPaging = try container.decodeIfPresent(Int.self, forKey: .nextPaging) ?? nil
    }
}

// MARK: - Datum
struct Datum: Codable,Hashable {
   
    let id: Int
    let category, title, description: String
    let price: Int
    let texture, wash, place, note: String
    let story: String
    let mainImage: String
    let images: [String]
    let variants: [Variant]
    let colors: [Color]
    let sizes: [String]

    enum CodingKeys: String, CodingKey {
        case id, category, title, description, price, texture, wash, place, note, story
        case mainImage = "main_image"
        case images, variants, colors, sizes
    }
}

// MARK: - Color
struct Color: Codable, Hashable {
    let code, name: String
}

// MARK: - Variant
struct Variant: Codable,Hashable {
    let colorCode, size: String
    let stock: Int

    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code"
        case size, stock
    }
}

// MARK: forHome
struct HomeJson: Codable,Hashable {
    let data: [HomeData]
}

struct HomeData: Codable,Hashable {
    let title: String
    let products: [Datum]
}

enum GHError: Error {
    case invalidURL
    case invalidData
    case decodingFailed
}

//MARK: --checkoutData

struct CheckoutData: Codable {
    let prime: String
    let order: Order
}

struct Order: Codable {
    let shipping, payment: String
    let subtotal, freight, total: Int
    let recipient: Recipient
    let list: [List]
}

struct List: Codable {
    let id, name: String
    let price: Int
    let color: Color
    let size: String
    let qty: Int
}


struct Recipient: Codable {
    let name, phone, email, address: String
    let time: String
}
