//
//  MainTableViewCell.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 08/09/2021.
//

import UIKit
protocol cellOutput : AnyObject
{
    
    func buttonClicked(sender:AnyObject)

}

class MainTableViewCell: UITableViewCell {

    weak var delegate: cellOutput?

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var buttonOrder: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        container.makeRoundborder()
        // Initialization code
        
        buttonOrder.setBackgroundColor(color: .black, forState: .normal)
        buttonOrder.setBackgroundColor(color: .systemGreen, forState: .highlighted)
        
        buttonOrder.setTitle("added + 1", for: .highlighted)
        buttonOrder.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)



    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
         //4. call delegate method
         //check delegate is not nil with `?`
        delegate?.buttonClicked(sender:self)
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    
}
