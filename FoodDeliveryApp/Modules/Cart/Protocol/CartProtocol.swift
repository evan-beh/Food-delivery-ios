//
//  CartProtocol.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 10/09/2021.
//



import UIKit
import RxSwift
import RxCocoa

protocol CartPresenterOutput : AnyObject {
    
    var cartList: BehaviorRelay<[MenuModel]> { get }

}

protocol CartListPresenterInput : AnyObject{
    
    func viewDidLoad()
    func calculateTotalAmount() -> Double
    func cancelOrder(index:Int)

}

protocol CartListRouterOutput : AnyObject{
    var view: UIViewController? { get  }
    static func createModule(entity:[MenuModel]) -> UIViewController


}




