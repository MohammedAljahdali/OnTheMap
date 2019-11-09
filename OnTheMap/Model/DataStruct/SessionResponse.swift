//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Mohammed Khakidaljahdali on 04/11/2019.
//  Copyright © 2019 Mohammed. All rights reserved.
//

import Foundation

struct Session: Codable {
    let id: String
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct SessionResponse: Codable {
    let account: Account
    let session: Session
}
