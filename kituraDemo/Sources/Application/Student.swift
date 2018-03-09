//
//  Student.swift
//  kitura-demo
//
//  Created by Moritz Philip Recke on 08/03/2018.
//

import Foundation
import SwiftKuery
import SwiftKueryPostgreSQL

public class Students : Table {
    let tableName = "students"
    let uniqueID = Column("uniqueID")
    let firstName = Column("firstName")
    let lastName = Column("lastName")
    let cohort = Column("cohort")
    let profile = Column("profile")
}

struct Student: Codable {
    
    //MARK: Properties
    var uniqueID: String
    var firstName: String
    var lastName: String
    var cohort: String
    var profile: String
    
    
    //MARK: Initialization
    init?(uniqueID: String, firstName: String, lastName: String, cohort: String, profile: String) {
        
        // Initialize stored properties.
        self.uniqueID = uniqueID
        self.firstName = firstName
        self.lastName = lastName
        self.cohort = cohort
        self.profile = profile
        
    }
}


