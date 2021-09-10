//
//  MenuService.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 10/09/2021.
//

import UIKit
import Moya

enum MenuService {
    case getMenu
    case getCategory
    case getAds
    case getFilter
    
}

extension MenuService: TargetType {
    
    
    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        return URL(string: "https://your-domain.com")!
    }
    
    // This is the path of each operation that will be appended to our base URL.
    var path: String {
        switch self {
        case .getMenu:
            return "/get"
            
        case .getCategory:
            return "/get"
            
        case .getAds:
            return "/get"
            
        case .getFilter:
            return "/get"
            
        }
    }
    
    // Here we specify which method our calls should use.
    var method: Moya.Method {
        switch self {
        case .getMenu:
            return .get
            
        case .getAds:
            return .get
            
        case .getFilter:
            return .get
            
        case .getCategory:
            return .get
            
            
            
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    // These are the headers that our service requires.
    // Usually you would pass auth tokens here.
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        
        
        switch self {
        case .getAds:
            
            let ads  = ["https://p.calameoassets.com/150811060200-482817bfbe4a6e03698d42248a62c51d/p1.jpg","https://p.calameoassets.com/150811060200-482817bfbe4a6e03698d42248a62c51d/p1.jpg","https://p.calameoassets.com/150811060200-482817bfbe4a6e03698d42248a62c51d/p1.jpg","https://p.calameoassets.com/150811060200-482817bfbe4a6e03698d42248a62c51d/p1.jpg","https://p.calameoassets.com/150811060200-482817bfbe4a6e03698d42248a62c51d/p1.jpg","https://p.calameoassets.com/150811060200-482817bfbe4a6e03698d42248a62c51d/p1.jpg","https://p.calameoassets.com/150811060200-482817bfbe4a6e03698d42248a62c51d/p1.jpg","https://p.calameoassets.com/150811060200-482817bfbe4a6e03698d42248a62c51d/p1.jpg","https://p.calameoassets.com/150811060200-482817bfbe4a6e03698d42248a62c51d/p1.jpg","https://p.calameoassets.com/150811060200-482817bfbe4a6e03698d42248a62c51d/p1.jpg"]
            
            guard let data = try? JSONSerialization.data(withJSONObject: ads, options: []) else {
                return Data()
            }
            
            return data
            
        case .getCategory:
            
            let category   = ["Pizza","Sushi","Drinks"]
            
            guard let data = try? JSONSerialization.data(withJSONObject: category, options: []) else {
                return Data()
            }
            
            
            return data
        case .getMenu:
            let data = Utility.readLocalJSONFile(forName: "menus") ?? Data()
            return data
        case .getFilter:
            let filter = ["Spicy","Vegan","Meat"]
            guard let data = try? JSONSerialization.data(withJSONObject: filter, options: []) else {
                return Data()
            }
            
            return data
        }
        
    }
    
    
}
