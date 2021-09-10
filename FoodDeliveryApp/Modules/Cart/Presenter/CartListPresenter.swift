//
//  CartPresenter.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 10/09/2021.
//

import UIKit
import RxSwift
import RxCocoa

typealias CartListDependencies = (
    interactor: CartListInteractor,
    router: CartRouter
)


protocol CartListInterface {
    var inputs: CartListPresenterInput { get }
    var outputs: CartPresenterOutput { get }
    
}


class CartListPresenter: CartListInterface, CartListPresenterInput, CartPresenterOutput {
       
    let cartList = BehaviorRelay<[MenuModel]>(value: [])

 
    private let disposeBag = DisposeBag()

    // MARK: - Properties
    var inputs: CartListPresenterInput { return self }
    var outputs: CartPresenterOutput { return self }
    var dependencies: CartListDependencies?
    
    init(dependent:CartListDependencies) {
        
        self.dependencies = dependent
        
    }
    
    func viewDidLoad() {
        
        let value = StoreManager.shared.cartList.value
        self.cartList.accept(value)
        
        StoreManager.shared.cartList
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] array in
                self?.cartList.accept(array)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func calculateTotalAmount() -> Double {
        return  self.dependencies?.interactor.calculateTotalAmount(items: self.cartList.value) ?? 0
    }
    
    func cancelOrder(index: Int) {
        
        var value = self.cartList.value
         value.remove(at: index)
        StoreManager.shared.cartList.accept(value)
    }
    
    
}
        
