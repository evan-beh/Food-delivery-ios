//
//  MainPresenter.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 09/09/2021.
//

import Moya
import RxSwift
import RxCocoa

typealias MenuListPresenterDependencies = (
    interactor: MainInteractor,
    router: MenuListRouter
)


protocol MenuListInterface {
    var inputs: MenuListPresenterInput { get }
    var outputs: MenuListPresenterOutput { get }
    
}

class MainPresenter: MenuListInterface, MenuListPresenterInput,MenuListPresenterOutput {
   
    func addToCart(order: [MenuModel]) {
        let value = self.cartList.value        
        let temp = value + order
        StoreManager.shared.cartList.accept(temp)
    }
    
   
    

    // Output
    var menuList = BehaviorRelay<[MenuModel]>(value: [])
    let categoryList = BehaviorRelay<[String]>(value: [])
    let filterList = BehaviorRelay<[String]>(value: [])
    let adsList = BehaviorRelay<[String]>(value: [])
    let cartList = BehaviorRelay<[MenuModel]>(value: [])

  
    // MARK: - Properties
    var inputs: MenuListPresenterInput { return self }
    var outputs: MenuListPresenterOutput { return self }
    var dependencies: MenuListPresenterDependencies?
    
      
    
    private let disposeBag = DisposeBag()

    init(dependent:MenuListPresenterDependencies) {
        
        self.dependencies = dependent
        

        
    }
  
    func viewDidLoad()
    {
        
        StoreManager.shared.cartList
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] array in
                self?.cartList.accept(array)
            })
            .disposed(by: disposeBag)
        
        
        
        
        let obsMenu = dependencies?.interactor.fetchMenus()
        obsMenu?
            .subscribe(onNext: { [weak self] array in

                var value = self?.menuList.value
                value?.removeAll()
                self?.menuList.accept(array)

            })
            .disposed(by: disposeBag)
        
        let obsCategory = dependencies?.interactor.fetchCategory()
        obsCategory?
            .subscribe(onNext: { [weak self] array in

                var value = self?.cartList.value
                value?.removeAll()
                self?.categoryList.accept(array)

            })
            .disposed(by: disposeBag)
        
        let obsFilter = dependencies?.interactor.fetchFilters()
        obsFilter?
            .subscribe(onNext: { [weak self] array in

                var value = self?.filterList.value
                value?.removeAll()
                self?.filterList.accept(array)

            })
            .disposed(by: disposeBag)
        
        let obsAds = dependencies?.interactor.fetchAds()
        obsAds?
            .subscribe(onNext: { [weak self] array in

                var value = self?.adsList.value
                value?.removeAll()
                self?.adsList.accept(array)
            })
            .disposed(by: disposeBag)
     
    }
    
    func gotoCart() {
        dependencies?.router.routeToCart(order: outputs.cartList.value)
    }
   
}
