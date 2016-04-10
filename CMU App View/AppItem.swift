//
//  AppItem.swift
//  CMU App View
//
//  Created by Gaury Nagaraju on 1/6/16.
//  Copyright © 2016 Gaury Nagaraju. All rights reserved.
//

import UIKit



class AppItem {
    // MARK: Properties
    
    var name: String
    var icon: UIImage?
    var link: String
    var order: Int
    var type: String
    
    // MARK: Initialization
    
    init(name: String, icon: UIImage, link: String, order:Int, type: String) {
        // Initialize stored properties.
        self.name = name
        self.icon = icon
        self.link = link
        self.order = order
        self.type = type
        
        // Initialization should fail if there is no name or if the rating is negative.
//        if name.isEmpty || link.isEmpty {
//            return nil
//        }
        

    }
    

}


