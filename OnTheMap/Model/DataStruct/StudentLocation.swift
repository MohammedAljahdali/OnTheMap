//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Mohammed Khakidaljahdali on 04/11/2019.
//  Copyright © 2019 Mohammed. All rights reserved.
//

import Foundation

struct Results: Codable {
    let results: [StudentLocation]
}

struct StudentLocation: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
}
