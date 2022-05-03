import Foundation

class Activity {
    let idActivity: String
    var name: String
    var description: String
    var estimatedTime: Int
    var scheduledTime: Int
    var realTime: Int
    var isTerminated: Bool
    
    init(idActivity: String, name: String, description: String, estimatedTime: Int, scheduledTime: Int, realTime: Int, isTerminated: Bool) {
        self.idActivity = idActivity
        self.name = name
        self.description = description
        self.estimatedTime = estimatedTime
        self.scheduledTime = scheduledTime
        self.realTime = realTime
        self.isTerminated = isTerminated
    }
}
