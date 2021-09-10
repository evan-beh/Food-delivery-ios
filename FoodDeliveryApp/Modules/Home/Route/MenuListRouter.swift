//
//  MenuListRouter.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 09/09/2021.
//

import UIKit



final class MenuListRouter: MenuListRouterOutput{
  
    weak var view: UIViewController?
    
    func routeToCart(order: [MenuModel]) {
        
        let vc = CartRouter.createModule(entity: order)
        
        self.view?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    init(view: UIViewController) {
        self.view = view
    }

}
