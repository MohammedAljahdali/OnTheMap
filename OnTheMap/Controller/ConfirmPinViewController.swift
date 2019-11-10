//
//  ConfirmPinViewController.swift
//  OnTheMap
//
//  Created by Mohammed Khakidaljahdali on 07/11/2019.
//  Copyright © 2019 Mohammed. All rights reserved.
//

import UIKit
import MapKit

class ConfirmPinViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var gecodingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gecodingIndicator.startAnimating()
        showLocation()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitStudentInformation(_ sender: Any) {
        OnTheMapAPI.postStudentLocation { (success, error, message) in
            DispatchQueue.main.async {
                if success {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                } else {
                    let alertVC = UIAlertController(title: "Submit Failed", message: message, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.show(alertVC, sender: nil)
                }
            }
        }
    }
    
}


extension ConfirmPinViewController: MKMapViewDelegate {
    
    func showLocation() {
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(OnTheMapAPI.UserData.latitude), longitude: CLLocationDegrees(OnTheMapAPI.UserData.longitude))
        let studentLocation = MKPointAnnotation()
        studentLocation.coordinate = coordinate
        studentLocation.title = "\(OnTheMapAPI.UserData.firstName) \(OnTheMapAPI.UserData.lastName)"
        studentLocation.subtitle = OnTheMapAPI.UserData.mediaURL
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(studentLocation)
        gecodingIndicator.stopAnimating()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
}
