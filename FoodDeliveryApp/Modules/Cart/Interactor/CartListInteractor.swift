//
//  CartInteractor.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 10/09/2021.
//

import UIKit


final class CartListInteractor {
        
     var totalAmount:Double = 0.00
        
    
    func calculateTotalAmount(items:[MenuModel]!) -> Double
    {
        totalAmount = 0
        
        if let array = items
        {
            for item in array
            {
                
                if let amount = item.menuPrice, let digit = Double(amount)
                {
                    totalAmount += digit

                }
                
            }
            
        }
      
        return totalAmount
        
    }
  
}
