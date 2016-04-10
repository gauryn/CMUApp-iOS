//
//  AppItemCollectionViewCell.swift
//  CMU App View
//
//  Created by Gaury Nagaraju on 12/31/15.
//  Copyright © 2015 Gaury Nagaraju. All rights reserved.
//

import UIKit

class AppItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var appItemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
