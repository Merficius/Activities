import Foundation
import CoreData
import UIKit

class Model {
    static var terminatedActivities: [Activity] = []
    static var notTerminatedActivities: [Activity] = []
    // Data useful for controllers
    static var scheduledTimers = [Int: Timer]()
    static var currentActivityId: Int64?


    // Creates a record in database with all the fields as parameters
    static func createRecordInDatabase(id: Int64, name: String, description: String, estimatedTime: Int64, scheduledTime: Int64, realTime: Int64, isTerminated: Bool) {
        var managedObject: NSManagedObject

        // We create a managed object into the managedobject context for the correspondent entity description
        entityDescription = NSEntityDescription.entity(forEntityName: "Activity", in: managedObjectContext!)
        managedObject = NSManagedObject(entity: entityDescription!, insertInto: Model.managedObjectContext)
        
        // Setting the values
        managedObject.setValue(id, forKey: "idActivity")
        managedObject.setValue(name, forKey: "activityName")
        managedObject.setValue(description, forKey: "activityDescription")
        managedObject.setValue(estimatedTime, forKey: "activityEstimatedTime")
        managedObject.setValue(scheduledTime, forKey: "activityScheduledTime")
        managedObject.setValue(realTime, forKey: "activityRealTime")
        managedObject.setValue(isTerminated, forKey: "activityIsTerminated")
        
        save()
    }
    
    // Selects all activities that are ended
    static func selectAllTerminatedActivities() -> [Activity] {
        var arrayOfManagedObjects: [Activity]
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        fetchRequest.predicate = NSPredicate(format: "activityIsTerminated == true")
        arrayOfManagedObjects = executeFetch()
        
        return arrayOfManagedObjects
    }
    
    // Selects all activities that are not ended
    static func selectAllNotTerminatedActivities() -> [Activity] {
        var arrayOfManagedObjects: [Activity]
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        fetchRequest.predicate = NSPredicate(format: "activityIsTerminated == false")
        arrayOfManagedObjects = executeFetch()
        
        return arrayOfManagedObjects
    }
    
    // Selects an activity by it's id
    static func selectActivityById(_ idActivity: Int64) -> Activity {
        var arrayOfManagedObjects: [Activity]
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        fetchRequest.predicate = NSPredicate(format: "idActivity == \(idActivity)")
        arrayOfManagedObjects = executeFetch()
        
        return arrayOfManagedObjects.first!
    
    }
    
    // Selects all activities ordered by a key (normally used with idActivity)
    static func selectAllActivities(orderedBy: String) -> [Activity] {
        var sortDescriptor: NSSortDescriptor
        var sortDescriptors: [NSSortDescriptor]
        var arrayOfManagedObjects: [Activity]
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        
        // When you execute a fetch, by default returnsObjectsAsFaults is true;
        // Core Data fetches the object data for the matching, fills the row cache with the information,
        // and returns managed object as faults.
        fetchRequest.returnsObjectsAsFaults = false
        
        // Sort descriptor to order the fetch
        sortDescriptor = NSSortDescriptor(key: orderedBy, ascending: false)
        sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        arrayOfManagedObjects = executeFetch()
        return arrayOfManagedObjects
    }
    
    // Updates a record in database with all the fields as parameters
    static func updateRecordInDatabase(id: Int64, name: String, description: String, estimatedTime: Int64, scheduledTime: Int64, realTime: Int64, isTerminated: Bool) {
        let activity = selectActivityById(id)
    
        activity.idActivity = id
        activity.activityName = name
        activity.activityDescription = description
        activity.activityEstimatedTime = estimatedTime
        activity.activityScheduledTime = scheduledTime
        activity.activityRealTime = realTime
        activity.activityIsTerminated = isTerminated
        
        save()
    }
    
    // Deletes a record in database with an id
    static func deleteRecordInDatabase(withId idActivity: Int64) {
        var managedObject: Activity
        
        managedObject = selectActivityById(idActivity)
        Model.managedObjectContext?.delete(managedObject)
        save()
        
    }
    
    // Deletes an activity with it's id
    static func deleteFromActivities(withId id: Int64) {
        var managedObject: Activity
        
        managedObject = selectActivityById(id)
        
        managedObjectContext?.delete(managedObject)
        
        save()
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
        
        // The name of our Entity in xcdatamodeld is "Activity"
        entityDescription = NSEntityDescription.entity(forEntityName: "Activity",
                                                       in: managedObjectContext!)
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
    
    
    // This function is only for testing/developing, it deletes all activities from the database
    static func deleteAllActivities() {
        var arrayOfManagedObjects: [Activity]
        
        arrayOfManagedObjects = selectAllActivities(orderedBy: "idActivity")
        
        // remove each one of the Managed Objects from the Managed Object Context
        for object in arrayOfManagedObjects {
            managedObjectContext?.delete(object)
        }
        
        save()
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
