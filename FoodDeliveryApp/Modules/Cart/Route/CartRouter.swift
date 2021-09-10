//
//  CartRouter.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 10/09/2021.
//

import UIKit



final class CartRouter: CartListRouterOutput{
   
    weak var view: UIViewController?
    
    // MARK: - Methods
    
    class func createModule(entity:[MenuModel]) -> UIViewController {
        
      
        let view = mainstoryboard.instantiateViewController(identifier: "cart") as CartViewController

        let interactor =  CartListInteractor()
        
        let router = CartRouter()
        
        router.view = view
        
        let dependencies = CartListDependencies(interactor: interactor, router: router)
        
        let presenter = CartListPresenter(dependent: dependencies)
                
        view.presenter = presenter
        
        
        
        return view
    }
    
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
