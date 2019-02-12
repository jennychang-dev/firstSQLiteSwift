import Foundation
import FMDB

class DataManager {

// sets up a DatabaseError enum so that we can throw errors if there's an issue
    
enum DatabaseError: Error {
    case open
    case executeStatement
}
    
    // creates a db property that will point to the FMDatabse - FMDB is used as a full featured wrapper for SQLite - it is used to create a database/create table/insert etc
    
    let db:FMDatabase
    
    init() throws {
        
        // sets the path to the database file, in this case it'll be a file named database.db inside the app's documents directory
        let dbName = "database.db"
        let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbName)
        
        // open the database and throw an error if there's a problem
        db = FMDatabase(url: fileURL)
        guard db.open() else {
            print("Error: \(db.lastErrorMessage())")
            return
        }
    }
    
    // close the database when the DataManager deinitializes
    deinit {
        db.close()
    }
    
    func setUpTables() throws {
        
        // create the SQL query
        let sql = """
    CREATE TABLE famous_people (
      id INTEGER PRIMARY KEY,
      first_name VARCHAR(50),
      last_name VARCHAR(50),
      birthdate VARCHAR(10)
    );

    INSERT INTO famous_people (first_name, last_name, birthdate)
      VALUES ('Dele', 'Alli', '1996-04-11');
    INSERT INTO famous_people (first_name, last_name, birthdate)
      VALUES ('Harry', 'Kane', '1993-07-28');
    INSERT INTO famous_people (first_name, last_name, birthdate)
      VALUES ('Paul', 'Pogba', '1993-03-15');
  """
        
        // 2
        if !db.executeStatements(sql) {
            throw DatabaseError.executeStatement
        }
        
    }

    func getAllFamousPeople() throws -> [Person] {
        
        // sets up the SELECT query
        let sql = """
       SELECT * FROM famous_people
        ORDER BY birthdate ASC;

    """
        // prepares an empty array to hold the people we get from the database
        var people = [Person]()
        
        // try to execute the qwery on the database which will return a FMResultSet when successful
        let resultSet = try db.executeQuery(sql, values: nil)
        
        // we must always call next() before attempting to access the values returned in a query - even if we're only expecting one value
        while resultSet.next() {
            // retrieve values for each record
            
            // create a new person object to hold the data
            let person = Person()
            
            // set its properties
            person.firstName = resultSet.string(forColumn: "first_name")
            person.lastName = resultSet.string(forColumn: "last_name")
            person.birthdate = resultSet.string(forColumn: "birthdate")
            
            // add to my array!
            people.append(person)
        }
        
        return people
    }
    
}


