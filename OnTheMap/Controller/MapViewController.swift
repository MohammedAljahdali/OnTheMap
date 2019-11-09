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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addPin))
        navigationItem.title = "Students Location"
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
        }
    }
    
    func setStudentLocations() {
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
    

