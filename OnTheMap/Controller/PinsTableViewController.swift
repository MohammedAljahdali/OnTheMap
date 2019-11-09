//
//  PinsTableViewController.swift
//  OnTheMap
//
//  Created by Mohammed Khakidaljahdali on 04/11/2019.
//  Copyright © 2019 Mohammed. All rights reserved.
//

import UIKit

class PinsTableViewController: UITableViewController {

    var studentLocations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OnTheMapAPI.getStudentLocation(completion: getStudentLocationHelper(studentLocations:error:))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addPin))
        navigationItem.title = "Students Info"
        
    }
    
    @objc func addPin() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addPin") as! AddPinViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func getStudentLocationHelper(studentLocations: [StudentLocation], error: Error?) {
        if error == nil {
            DispatchQueue.main.async {
                self.studentLocations = studentLocations
                self.studentLocations.append(contentsOf: AddedStudent.students)
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        let row = studentLocations[indexPath.row]
        cell.textLabel?.text = "\(row.firstName) \(row.lastName)"
        cell.detailTextLabel?.text = "\(row.mapString)"
        return cell
    }


}