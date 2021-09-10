//
//  CartTableViewCell.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 08/09/2021.
//

import UIKit


class CartTableViewCell: UITableViewCell {
   
       
    weak var delegate: cellOutput?

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var btnCancel: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnCancel?.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    @IBAction func buttonClicked(sender: AnyObject) {
       
        
        delegate?.buttonClicked(sender:self)
     }
}
