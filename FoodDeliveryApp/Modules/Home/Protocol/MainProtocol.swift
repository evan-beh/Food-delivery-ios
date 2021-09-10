//
//  MainProtocol.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 09/09/2021.
//

import UIKit
import RxSwift
import RxCocoa


protocol MenuListPresenterOutput : AnyObject {
    
    var menuList: BehaviorRelay<[MenuModel]> { get }
    var cartList: BehaviorRelay<[MenuModel]> { get }
    var adsList: BehaviorRelay<[String]> { get }
    var categoryList: BehaviorRelay<[String]> { get }
    var filterList: BehaviorRelay<[String]> { get }
}


protocol MenuListPresenterInput : AnyObject{
    
    func viewDidLoad()
    func gotoCart()
    func addToCart(order:[MenuModel])


}

protocol MenuListRouterOutput : AnyObject{
    var view: UIViewController? { get  }


}
