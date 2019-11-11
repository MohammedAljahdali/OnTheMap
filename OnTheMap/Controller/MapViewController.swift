//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Mohammed Khakidaljahdali on 06/11/2019.
//  Copyright © 2019 Mohammed. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var studentLocations = [StudentLocation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addPin))
        navigationItem.title = "Students Location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
    }
    
    @objc func logout() {
        OnTheMapAPI.logout() { success, error in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                let alertVC = UIAlertController(title: "Logout Failed", message: error!.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.show(alertVC, sender: nil)
            }
        }
    }
    
    @objc func addPin() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addPin") as! AddPinViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OnTheMapAPI.getStudentLocation(completion: getStudentLocationHelper(studentLocations:error:))
    }
    
    func getStudentLocationHelper(studentLocations: [StudentLocation], error: Error?) {
        if error == nil {
            DispatchQueue.main.async {
                self.studentLocations = studentLocations
                self.studentLocations.append(contentsOf: AddedStudent.students)
                self.setStudentLocations()
            }
        } else {
                let alertVC = UIAlertController(title: "Network Issue", message: "Check Your Connection", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.show(alertVC, sender: nil)
            }
        }
    
    func setStudentLocations() {
        mapView.removeAnnotations(mapView.annotations)
        var studentAnnotations = [MKPointAnnotation]()
        for dictionary in studentLocations {
                    let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(dictionary.latitude), longitude: CLLocationDegrees(dictionary.longitude))
                    let studentLocation = MKPointAnnotation()
                    studentLocation.coordinate = coordinate
                    studentLocation.title = "\(dictionary.firstName) \(dictionary.lastName)"
                    studentLocation.subtitle = dictionary.mediaURL
                    studentAnnotations.append(studentLocation)
               }
               self.mapView.addAnnotations(studentAnnotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.isEnabled = true
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let subtitle = view.annotation?.subtitle else {return}
            let url = URL(string: subtitle!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
}
    


