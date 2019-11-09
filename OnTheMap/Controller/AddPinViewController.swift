//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Mohammed Khakidaljahdali on 07/11/2019.
//  Copyright © 2019 Mohammed. All rights reserved.
//

import UIKit
import CoreLocation

class AddPinViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.text = ""
        mediaTextField.text = ""
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        guard let location = locationTextField.text,
            let media = mediaTextField.text,
            locationTextField.text != "",
            mediaTextField.text != ""
            else {
                showAddPinFailure(message: "Fill the text fields!")
                return
            }
        getCoordinateFrom(address: locationTextField.text ?? "") { (coordinate, error) in
            guard let coordinate = coordinate else {
                DispatchQueue.main.async {
                    self.showAddPinFailure(message: "Enter a correct location!")
                }
                return
            }
            DispatchQueue.main.async {
                OnTheMapAPI.UserData.latitude = coordinate.latitude
                OnTheMapAPI.UserData.longitude = coordinate.longitude
                OnTheMapAPI.UserData.mapString = location
                OnTheMapAPI.UserData.mediaURL = media
                print(media+location)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "confirmPin") as! ConfirmPinViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1)}
    }
    
    func showAddPinFailure(message: String) {
        let alertVC = UIAlertController(title: "Add Pin Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }

    
}
