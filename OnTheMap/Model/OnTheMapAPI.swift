//
//  OnTheMapAPI.swift
//  OnTheMap
//
//  Created by Mohammed Khakidaljahdali on 04/11/2019.
//  Copyright © 2019 Mohammed. All rights reserved.
//

import Foundation

public class OnTheMapAPI {
    struct UserData {
        static var firstName = ""
        static var lastName = ""
        static var longitude = 0.0
        static var latitude = 0.0
        static var mapString = ""
        static var mediaURL = ""
        static var uniqueKey = ""
        static var objectId = ""
        static var didPost = false
    }
    
    
    enum EndPoints {
        case getStudentLocation
        case session
        case postStudentLocation
        case getUserInfo
        
        var stringValue: String {
            switch self {
            case .getStudentLocation:
                return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .session:
                return "https://onthemap-api.udacity.com/v1/session"
            case .postStudentLocation:
                return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=updatedAt"
            case .getUserInfo:
                return "https://onthemap-api.udacity.com/v1/users/\(UserData.uniqueKey)"
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    
    class func getStudentLocation(completion: @escaping ([StudentLocation], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoints.getStudentLocation.url) { (data, response, error) in
            guard let data = data else {completion([], error); return}
            do {
                let studentLocationObject = try JSONDecoder().decode(Results.self, from: data)
                completion(studentLocationObject.results,nil)
            }
            catch {completion([], error)}
        }
        task.resume()
    }
    
    class func createSession(email: String, password: String, completion: @escaping (Bool, Error?, String) -> Void) {
        var request = URLRequest(url: EndPoints.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {completion(false, error, error?.localizedDescription ?? ""); return}
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            do {
                let object = try JSONDecoder().decode(SessionResponse.self, from: newData)
                UserData.uniqueKey = object.account.key
                //getUserInfo is supposed to get the first and last names but it does not work for me
//                OnTheMapAPI.getUserInfo()
                UserData.firstName = "Max"
                UserData.lastName = "Min"
                completion(object.account.registered, nil, "")
            } catch {
                print(error.localizedDescription)
                let jsonResponse = try! JSONSerialization.jsonObject(with: newData, options: [])
                let json = jsonResponse as! [String: Any]
                guard let errorDescription = json["error"] as? String else {return}
                completion(false, error, errorDescription)
            }
        }
        task.resume()
    }
    
    class func postStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: EndPoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(UserData.uniqueKey)\", \"firstName\": \"\(UserData.firstName)\", \"lastName\": \"\(UserData.lastName)\",\"mapString\": \"\(UserData.mapString)\", \"mediaURL\": \"\(UserData.mediaURL)\",\"latitude\": \(UserData.latitude), \"longitude\": \(UserData.longitude)}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {completion(false, error); return}
            do {
            let object = try JSONDecoder().decode(PostingStudentResponse.self, from: data)
                AddedStudent.students.append(StudentLocation(firstName: UserData.firstName, lastName: UserData.lastName, longitude: UserData.longitude, latitude: UserData.latitude, mapString: UserData.mapString, mediaURL: UserData.mediaURL, uniqueKey: UserData.uniqueKey, objectId: object.objectId))
                completion(true,nil)
            } catch {completion(false, error)}
        }
        task.resume()
    }
    
//    class func getUserInfo() {
//        let request = URLRequest(url: EndPoints.getUserInfo.url)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {print(error); return}
//            let range = 5..<data.count
//            let newData = data.subdata(in: range)
//            do {
//                print(EndPoints.getUserInfo.stringValue)
//                let object = try JSONDecoder().decode(User.self, from: newData)
//                UserData.firstName = object.user.firstName
//                UserData.lastName = object.user.lastName
//                print(object)
//            } catch {print(error)}
//        }
//        task.resume()
//    }
    
}
