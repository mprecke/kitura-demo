//
//  DBConnection.swift
//  kitura-demo
//
//  Created by Moritz Philip Recke on 08/03/2018.
//


import Foundation
import SwiftKuery
import SwiftKueryPostgreSQL

final class DBConnection {
    
    public static let shared = DBConnection()
    
    let defaultDBHost: String
    var connection: PostgreSQLConnection
    
    private init(){
        defaultDBHost = "localhost"
        connection = PostgreSQLConnection(url: URL(string: defaultDBHost)!)
        self.getPostgrSQLConnection()
    }
    
    func getPostgrSQLConnection() {
        // Setup DB connections to use the correct DB_URL depending on the environment the project is run in.
        let dbHost: URL

        // Check if we are running on Heroku by requesting DB_URL from Heroku environment variables
        if let requestedHost = ProcessInfo.processInfo.environment["DATABASE_URL"] {
            // There is an annoying feature in Kitura that requires us to make the postgres address coming from Heroku to have an uppercase first letter
            var urlComp = URLComponents(string: requestedHost)
            urlComp?.scheme = "Postgres"
        
            if let url = urlComp?.url {
                dbHost = url
            } else {
                dbHost = URL(string: defaultDBHost)!
            }
        
        } else {
            dbHost = URL(string: defaultDBHost)!
        }
        connection = PostgreSQLConnection(url: dbHost)
    }
}

