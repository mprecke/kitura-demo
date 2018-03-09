//
//  ViewController.swift
//  iOSKituraKitSample
//
//  Created by Moritz Philip Recke on 08/03/2018.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
import KituraKit

class ViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var cohort: UITextField!
    @IBOutlet weak var profile: UITextField!
    @IBOutlet weak var id: UITextField!
    
    @IBAction func addStudent(_ sender: Any) {
        
        guard let theFirstName = firstName.text else {print("error firstName")
            return}
        guard let theLastName = lastName.text else {print("error lastName")
            return}
        guard let theCohort = cohort.text else {print("error cohort")
            return}
        guard let theProfile = profile.text else {print("error profile")
            return}
        guard let theId = id.text else {print("error id")
            return}
        
        saveStudentToServer(newStudent: Student(uniqueID: theId, firstName: theFirstName, lastName: theLastName, cohort: theCohort, profile: theProfile)!)
        
        firstName.text = ""
        lastName.text = ""
        cohort.text = ""
        profile.text = ""
        id.text = ""
        
    }
    
    var sampleStudent: Student = Student(uniqueID: "0042", firstName: "John", lastName: "Doe", cohort: "afternoon", profile: "geek")!

    private func saveStudentToServer(newStudent: Student) {
        guard let client = KituraKit(baseURL: "https://kiturademo.herokuapp.com") else {
            print("Error creating KituraKit client")
            return
        }
        client.post("/students", data: newStudent) { (newStudent: Student?, error: Error?) in
            guard error == nil else {
                //print("Error saving Noise to Kitura: \(error!)")
                return
            }
            print("Saving Student to Kitura succeeded")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveStudentToServer(newStudent: sampleStudent)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
