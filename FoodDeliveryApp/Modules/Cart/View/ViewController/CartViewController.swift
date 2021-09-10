//
//  CartViewController.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 08/09/2021.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController, cellOutput {
   
    
    private let disposeBag = DisposeBag()

    func buttonClicked(sender: AnyObject) {
        
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
               print(indexPath!.row)
       
        self.presenter?.inputs.cancelOrder(index: indexPath!.row)
        
    }
    
    // MARK: - Properties
    var presenter: CartListInterface?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndex = IndexPath(row: 0, section: 0)
    
    let array  = ["Cart","Order","Information"]
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setupCollectionView()
        setupBinding()
        // Do any additional setup after loading the view.
    }
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.separatorColor = UIColor.clear


        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "CartFooterView", bundle: nil), forCellReuseIdentifier: "cell2")

        
        self.presenter?.inputs.viewDidLoad()

    }
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
    }

    
    func setupBinding()
    {
        
        
        self.presenter?.outputs.cartList.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CartViewController : UITableViewDelegate, UITableViewDataSource
{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 1)
        {
            
            return 1
            
        }
        else{

            let count = self.presenter?.outputs.cartList.value.count
            return count!

        }
        
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if (indexPath.section == 1)
        {
            return 110
        }
        else{
            
           return 130
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section  == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! CartTableViewCell

            
            let price =  String(format: "%.2f", self.presenter?.inputs.calculateTotalAmount() ?? 0)
            cell.title.text =  "\(price) usd"
            
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableViewCell

            if let item = self.presenter?.outputs.cartList.value[indexPath.row]
            {

                let url = URL(string: item.menuThumnailImageUrl ?? "")

                cell.imgView.af.setImage(withURL: url!)

                cell.title.text = item.menuName

                let price =  item.menuPrice ?? ""
                cell.desc.text = "\(price) usd"

                cell.delegate = self
            }
            
          
            return cell
        }
         
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 100
    }

        
}


extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! CategorySelectorCollectionViewCell
        
        
        let string = array[indexPath.row]
        cell.title.text = string
        
        cell.setSelected(selectedIndex.row == indexPath.row, animated: false)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath != selectedIndex){
            let indexPath_pre = selectedIndex
            let indexPath_post = indexPath
            
            let array = [indexPath_pre,indexPath_post]
           
            self.selectedIndex = indexPath
            
            collectionView.reloadItems(at: array)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {

        let value = (Int(array[indexPath.row].count) *  20) + 32
        
        return CGSize(width: value, height: 50)


   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 0
    }
    
    
    
}

    
