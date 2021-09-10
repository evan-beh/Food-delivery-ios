//
//  Utility.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 09/09/2021.
//

import UIKit

class Utility: NSObject {

    
    static func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}
