//
//  BusinessCell.swift
//  Yelp
//
//  Created by Pranav Achanta on 1/26/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    // OutLets for Business Cell
    
    @IBOutlet weak var ThumbNail: UIImageView!
    @IBOutlet weak var Rating: UIImageView!
    
    
    @IBOutlet weak var BusinessName: UILabel!
    @IBOutlet weak var Distance: UILabel!
    @IBOutlet weak var numberOfReviews: UILabel!
    @IBOutlet weak var priceRange: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var cuisine: UILabel!
    
    
    var business : Business!{
        // DisSet is an observer --> From the observer pattern i guess!!
        didSet {
            if let image = business.imageURL{
                ThumbNail.setImageWithURL(image)
            }
            BusinessName.text = business.name!
            Distance.text = business.distance!
            numberOfReviews.text = "\(business.reviewCount!) Reviews"
            address.text = business.address!
            cuisine.text = business.categories!
            if let ratingUrl = business.ratingImageURL{
                Rating.setImageWithURL(ratingUrl)
            }
        }
    }
    
    override func layoutSubviews() {
        // Always call the Parent SubView
        super.layoutSubviews()
        
        // Preferred Wrapping Point
        BusinessName.preferredMaxLayoutWidth = BusinessName.frame.size.width
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ThumbNail.layer.cornerRadius = 3
        ThumbNail.clipsToBounds = true
        
        // Preferred Wrapping Point
        BusinessName.preferredMaxLayoutWidth = BusinessName.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
