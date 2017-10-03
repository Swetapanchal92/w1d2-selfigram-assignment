//
//  Post.swift
//  w1d2 selfigram
//
//  Created by Nitin Panchal on 2017-09-08.
//  Copyright © 2017 Sweta panchal. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Post: PFObject, PFSubclassing {
    
    @NSManaged var image:PFFile
    @NSManaged var user:PFUser
    @NSManaged var comment:String
    
    static func parseClassName() -> String {
        // sets what the table name on Parse will be called
        return "Post"
    }
    
    convenience init(image:PFFile, user:PFUser, comment:String){
        
        self.init()
        self.image = image
        self.user = user
        self.comment = comment
    }
    
    var likes: PFRelation<PFObject>! {
        // PFRelations are a bit different from just a regular properties
        // This is called a “computed property”, because it’s value is computed every time instead of stored.
        // The line below specifies that our relation column on Parse should be called “likes”
        return relation(forKey: "likes")
    }

    
    
}

