# kitura-demo
Sample Kitura Project with PostgreSQL and Sample iOS Client Project.

The Kitura Project was created with the Command Line on Mac OS X with Terminal. 

# Prerequisites are:

- Install Xcode and setup Command Line Tools for Xcode, run in Terminal:  

        $ xcode-select --install
 
 - Install Homebrew and Homebrew Tap, run in Terminal:
 
        $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    
        $ brew tap ibm-swift/kitura

- Install Kitura's command line interface, run in Terminal:

        $ brew install kitura


# To start Kitura Project:

- Build Kitura Project in Console, run in Terminal:

        $ kitura create

    This will allow you to create a Kitura Project based on presets. For the Demo I provided 
    - a NAME
    - a DIRECTORY
    - chose SCAFFOLD A STARTER as type or project
    - chose WEB as capability presets (as it contains options to host static web content as well) 
    - chose STATIC WEB FILE SERVING, EMBEDDED METRICS DASHBOARD and DOCKER FILES as capabilities
    - chose NO endpoints to generate
    - did NOT generate a Swift Server SDK
    - did NOT create any boilerplate for services (although this is a good option offered by Kitura)

- Open Xcode Project and change Target to run the Application created
- Check http://localhost:8080 to see up and running Kitura server

# Create basic API with HTTP requests:

- In Application.swift file add to the postInit() function e.g.

        // Handle HTTP GET requests to /
        router.get("/") {
        	request, response, next in
        	response.send("Hello, World!")
		next() 
        }

- for requests that handle data consider:

        //GET request on all Students
        router.get("/students", handler: loadAllStudentsHandler)
        // POST request on noiseLevels, posting a noiseLevel
        router.post("/students", handler: storeStudentHandler)

- Add Implementations for the handlers to deal with the requests, e.g.:

        // loadHandler that returns the stored Students.
        func loadAllStudentsHandler(completion: @escaping ([Student]?, RequestError?) -> Void ) {
        	//get the data from storage and return it
        	completion("ARRAY OF STUDENDTS", nil)         
        }
   
        // storeHandler that receives a Student and saves it
        func storeStudentHandler(newStudent: Student, completion: @escaping (Bool, RequestError?) -> Void ) {
        	//save the student in storage
        
        	completion(true, nil)
        }

# Connect to PostgreSQL Database

The implemented Singleton in DBConnection.swift is ment for hosting the Kitura Server on Heroku and using the PostgreSQL service provided by Heroku insude the corrsponding Heroku Project. It can be adapted to connect to any other PostgreSQL databse but using appropriate connection data, such as:
    
        connection = PostgreSQLConnection(host: "HOST URL", port: 5432, options: [.userName("USERNAME"), .password("PASSWORD"), .databaseName("DATABASE NAME")])
    

# Use iOS Client Sample Project to connect to Server:

The Xcode Project is configured to be ready to use. If a new Project is created, it needs to be configured with a Podfile to incorporate the Kitura Framework. 

- Create a Podfile within a new iOS Xcode Project Folder, in Terminal:

        $ pod init 

- Open created Podfile and save it with following content:

        # Uncomment the next line to define a global platform for your project
        platform :ios, '11.0'

        target 'iOSKituraKitSample' do
        	# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
        	use_frameworks!

        # Pods for iOSKituraKitSample

        pod 'KituraKit', :git => 'https://github.com/IBM-Swift/KituraKit.git', :branch => 'pod'

        	target 'iOSKituraKitSampleTests' do
        	inherit! :search_paths
		# Pods for testing
        	end

        end
    
 - Install Kitura Pod, in Terminal:
        
	$ pod install

- Open .xcworkspace not XCode Project file to work with Kitura Pod in the Xcode Project

- In Sourcefiles that use Kitura, add:
        
	import KituraKit

- To access Kitura Server, use syntax as follows:

        private func saveStudentToServer(newStudent: Student) {
        	guard let client = KituraKit(baseURL: "https://kiturademo.herokuapp.com") else {
            		print("Error creating KituraKit client")
            		return
        	}
        	client.post("/students", data: newStudent) { (newStudent: Student?, error: Error?) in
            		guard error == nil else {
                	//print("Error saving Student data to Kitura: \(error!)")
                	return
        	}
        	print("Saving Student to Kitura succeeded")
        	}
        }
    
    	private func loadStudentsFromServer() {
        	studentsLoaded.removeAll()
        	guard let client = KituraKit(baseURL: "https://kiturademo.herokuapp.com") else {
        		print("Error creating KituraKit client")
        		return
        	}
        	client.get("/students") { (students: [Student]?, error: Error?) in
        		guard error == nil else {
        		print("Error getting student data from Kitura: \(error!)")
        		return
			}
			guard let students = students else {
				self.studentsLoaded = [Student]()
				return
			}
			self.studentsLoaded = students.sorted(by: { $0.lastName < $1.lastName })
				DispatchQueue.main.async { [unowned self] in
				print(self.studentsLoaded)
				self.tableView!.reloadData()
			}
		}
        }
    
