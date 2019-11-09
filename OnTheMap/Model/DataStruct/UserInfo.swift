//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Mohammed Khakidaljahdali on 07/11/2019.
//  Copyright © 2019 Mohammed. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    // get user first name and last name
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct User: Codable {
    let user : UserInfo
}
