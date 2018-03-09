import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import SwiftKuery
import SwiftKueryPostgreSQL

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()



public class App {
    let router = Router()
    let cloudEnv = CloudEnv()
    
    let students = Students()
    
    public init() throws {
        // Run the metrics initializer
        initializeMetrics(router: router)
    }
    
    var studentArray: [Student] = [Student.init(uniqueID: "0001", firstName: "Mauritzo", lastName: "Recke", cohort: "morning", profile: "master")!]
    
    func postInit() throws {
        // Middleware
        router.all(middleware: StaticFileServer())
        // Endpoints
        initializeHealthRoutes(app: self)

        // Handle HTTP GET requests to /
        router.get("/") {
            request, response, next in
            response.send("Hello, World!")
            next()
        }
        
        //GET request on all Students
        router.get("/students", handler: loadAllStudentsHandler)
        
        // POST request on noiseLevels, posting a noiseLevel
        router.post("/students", handler: storeStudentHandler)
    }
    
    // loadHandler that returns the stored Students.
    func loadAllStudentsHandler(completion: @escaping ([Student]?, RequestError?) -> Void ) {
        
        DBConnection.shared.connection.connect() { error in
            if error != nil {return}
            else {
                // Build and execute your query here.
                let selectQuery = Select(from: self.students)
                DBConnection.shared.connection.execute(query: selectQuery) { queryResult in
                    // Handle your result here
                    var tempStudents = [Student]()
                    if let resultSet = queryResult.asResultSet {
                        for row in resultSet.rows {
                            // Process rows
                            guard let uniqueID = row[0], let uniqueIDString = uniqueID as? String else {return}
                            guard let fistName = row[1], let fistNameString = fistName as? String else {return}
                            guard let lastName = row[2], let lastNameString = lastName as? String else {return}
                            guard let cohort = row[3], let cohortString = cohort as? String else {return}
                            guard let profile = row[4], let profileString = profile as? String else {return}
                            
                            guard let currentStudent = Student(uniqueID: uniqueIDString, firstName: fistNameString, lastName: lastNameString, cohort: cohortString, profile: profileString)
                                else {return}
                            tempStudents.append(currentStudent)
                        }
                    }
                    completion(tempStudents, nil)
                }
            }
        }
    }
    
    // storeHandler that receives a Student and saves it
    func storeStudentHandler(newStudent: Student, completion: @escaping (Bool, RequestError?) -> Void ) {
        DBConnection.shared.connection.connect() { error in
            if error != nil {
                completion(false, nil)
                return
            }
            else {
                // Build and execute your query here.
                //RAW queries are possible and shown here for reference, altough they are not secure and should be avoided.
                let insertRawQuery = "INSERT INTO students VALUES ( '\(newStudent.uniqueID)', '\(newStudent.firstName)', '\(newStudent.lastName)', '\(newStudent.cohort)', '\(newStudent.profile)');"
                DBConnection.shared.connection.execute(insertRawQuery) { result in
                    // Respond to the result here
                    completion(true, nil)
                }
            }
        }
    }
    
    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}

