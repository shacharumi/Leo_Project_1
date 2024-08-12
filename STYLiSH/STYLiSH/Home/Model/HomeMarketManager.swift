//
//  marketManager.swift
//  STYLiSH
//
//  Created by shachar on 2024/7/19.
//

import UIKit
import Foundation

protocol HomeMarketManagerDelegate: AnyObject {
    func manager(_ manager: HomeMarketManager, didGet homeJsonData: HomeJson)
    
    func manager(_ manager: HomeMarketManager, didFailWith error: Error)
}

class HomeMarketManager {
    weak var delegate: HomeMarketManagerDelegate?
    
    func getMarketingHots() async throws -> HomeJson {
        let url = "https://api.appworks-school.tw/api/1.0/marketing/hots"
        if let requestURL = URL(string: url) {
            let (data, _) = try await URLSession.shared.data(from: requestURL)
            let decoder = JSONDecoder()
            let marketingHots = try decoder.decode(HomeJson.self, from: data)
            
            return marketingHots
        } else {
            throw GHError.invalidURL
        }
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
