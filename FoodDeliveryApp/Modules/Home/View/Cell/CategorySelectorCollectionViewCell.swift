//
//  CategorySelectorCollectionViewCell.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 09/09/2021.
//

import UIKit

class CategorySelectorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!

    func setSelected(_ selected: Bool, animated: Bool) {

       if (selected)
       {
           self.title.textColor = UIColor.black
           
       }
       else{
           
           self.title.textColor = UIColor.lightGray
       }
       
       // Configure the view for the selected state
   }
}
