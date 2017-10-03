//
//  User.swift
//  w1d2 selfigram
//
//  Created by Nitin Panchal on 2017-09-08.
//  Copyright © 2017 Sweta panchal. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    let username:String
    let profileImage:UIImage
    
    init(aUsername:String, aProfileImage:UIImage){
        //we are setting the User property of "username" to an aUsername property you are going to pass in
        username = aUsername
        profileImage = aProfileImage
    }
    
}
