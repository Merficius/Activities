import Foundation

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
        return [Activity(idActivity: "e", name: "e", description: "e", estimatedTime: 2, scheduledTime: 4, realTime: 2, isTerminated: true)]
    }
    
    func selectAllNotTerminatedActivities() -> [Activity] {
        return [Activity(idActivity: "e", name: "e", description: "e", estimatedTime: 2, scheduledTime: 4, realTime: 2, isTerminated: true)]
    }
        
    func selectActivityById(_ idActivity: String) -> Activity {
        return Activity(idActivity: "e", name: "e", description: "e", estimatedTime: 2, scheduledTime: 4, realTime: 2, isTerminated: true)
    }
}
