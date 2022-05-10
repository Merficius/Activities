import Foundation
import CoreData
import UIKit

class Model {
    var Activities: [Activity]
    
    init() {
        Activities = []
    }
    
    func createRecordInDatabase(withId idActivity: String) {
        
    }
    
    func updateRecordInDatabase(withId idActivity: String) {
        
    }
    
    func deleteRecordInDatabase(withId idActivity: String) {
        
    }
    
    func selectAllTerminatedActivities() -> [Activity] {
        return [Activity]()
    }
    
    func selectAllNotTerminatedActivities() -> [Activity] {
        return [Activity]()
    }
    
    func selectActivityById(_ idActivity: String) -> Activity {
        return Activity()
    }
}

extension Model {
    // Core Data:
    // An object graph persistence framework.
    
    // Usually data is stored in a SQLite database.
    
    // Persistence framework:
    // assists and automates the storage of program data into databases,
    // especially relational databases.
    
    // Managed Object Model:
    // An object that describes the schema of the data base.
    // Is a collection of entities (data models)
    // The model is a collection of entity description objects
    // (instances of NSEntityDescription).
    //
    
    // Managed Object:
    // Represents data held in the persistent store.
    // Acts like a dictionary.
    // It is a generic container object that efficiently provides storage for the properties
    // defined by its associated NSEntityDescription object.
    
    // Managed Object Context:
    // Group of related model objects
    // that represents an internally consistent view of one or more persistent stores.
    static var managedObjectContext : NSManagedObjectContext? = nil
    
    
    // Entity Description:
    // Describes an entity.
    // Entities correspond to the "tables" of the database.
    static var entityDescription : NSEntityDescription? = nil
    
    // NSFetchRequest is a description of search criteria
    // used to retrieve data from a persistent store.
    // NSFetchRequestResult is an abstract protocol
    // used with parameterized fetch requests.
    static var fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    
    
    /////////////////////////////////////////////////////////////////
    
    
    // Obtains the Managed Object Context
    // and the Entity Description.
    static func initialize() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // The name of our Entity in xcdatamodeld is "Users"
        entityDescription = NSEntityDescription.entity(forEntityName: "Activity",
                                                       in: managedObjectContext!)
        
        insertIntoUsers(idActivity: "hola2", name: "dsas23", description: "wqenwie")
        print(selectAllFromUsers())
    }
    
    // A fetch to the Managed Object Context
    // results in an Array Of Managed Objects (Activities)
    static func executeFetch() -> [Activity] {
        var arrayOfManagedObjects: [Activity] = []
        
        do {
            arrayOfManagedObjects = (try managedObjectContext?.fetch(Model.fetchRequest))! as! [Activity]
        }
        catch {
            print("Fetch Failed.")
        }
        return arrayOfManagedObjects
    }
    
    static func selectAllFromUsers() -> [Activity] {
        var arrayOfManagedObjects: [Activity]
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        
        // When you execute a fetch, by default returnsObjectsAsFaults is true;
        // Core Data fetches the object data for the matching records,
        // fills the row cache with the information,
        // and returns managed object as faults.
        fetchRequest.returnsObjectsAsFaults = false
        
        arrayOfManagedObjects = executeFetch()
        return arrayOfManagedObjects
    }
    
    static func selectAllFromUsers(orderBy: String) -> [Activity] {
        var sortDescriptor: NSSortDescriptor
        var sortDescriptors: [NSSortDescriptor]
        var arrayOfManagedObjects: [Activity]
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        fetchRequest.returnsObjectsAsFaults = false
        // we include a sort descriptor
        sortDescriptor = NSSortDescriptor(key: orderBy, ascending: true)
        sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        arrayOfManagedObjects = executeFetch()
        return arrayOfManagedObjects
    }
    
    static func selectAllFromUsersWhere(username: String) -> [Activity] {
        var arrayOfManagedObjects: [Activity]
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        arrayOfManagedObjects = executeFetch()
        return arrayOfManagedObjects
    }
    
    static func selectTop1FromUsersWhere(username: String) -> Activity {
        var arrayOfManagedObjects: [Activity]
        var firstObject: Activity
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        arrayOfManagedObjects = executeFetch()
        firstObject = arrayOfManagedObjects.first!
        return firstObject
    }
    
    // We create a Managed Object into the Managed Object Context
    // for the correspondent Entity Description.
    // Then we set the corresponding values (data).
    static func insertIntoUsers(idActivity: String, name: String, description: String) {
//        var managedObject: NSManagedObject
        let activity: Activity!
        
//        entityDescription = NSEntityDescription.entity(forEntityName: "Activity", in: managedObjectContext!)
//        managedObject = NSManagedObject(entity: entityDescription!, insertInto: managedObjectContext)
//        managedObject.setValue(idActivity, forKey: "idActivity")
//        managedObject.setValue(name, forKey: "activityName")
//        managedObject.setValue(description, forKey: "activityDescription")
        
        
        var arrayOfManagedObjects: [Activity]

        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        fetchRequest.predicate = NSPredicate(format: "idActivity == %@", idActivity)
        arrayOfManagedObjects = executeFetch()

        if arrayOfManagedObjects.count == 0 {
           // here you are inserting
           activity = Activity(context: managedObjectContext!)
        } else {
           // here you are updating
           activity = arrayOfManagedObjects.first!
        }

        activity.idActivity = idActivity
        activity.activityName = name
        activity.activityDescription = description
        
        Model.save()
    }
    
    
    
    // we did not code the Users class
    static func deleteAllFromUsers() {
        var arrayOfManagedObjects: [Activity]
        
        arrayOfManagedObjects = selectAllFromUsers()
        
        // remove each one of the Managed Objects from the Managed Object Context
        for object in arrayOfManagedObjects {
            managedObjectContext?.delete(object)
        }
    }
    
    static func deleteFromUsersWhere(username: String) {
        var managedObject: Activity
        
        managedObject = selectTop1FromUsersWhere(username: username)
        managedObjectContext?.delete(managedObject)
    }
    
    // Try to save the Managed Object Context
    static func save() {
        do {
            try managedObjectContext?.save()
        }
        catch {
            print("Failed saving")
        }
    }
}
