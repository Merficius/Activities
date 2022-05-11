import UIKit

class EditActivityController: UIViewController {
    @IBOutlet var activityName: UITextField!
    @IBOutlet var activityDescription: UITextView!
    @IBOutlet var activityEstimatedTime: UIDatePicker!
    @IBOutlet var activityHasScheduledTime: UISwitch!
    @IBOutlet var activityScheduledTime: UIDatePicker!
    @IBOutlet var activityRealTime: UIDatePicker!
    @IBOutlet var editActivityTitleLabel: UILabel!
    var controllerTitle: String = ""
    var currentActivityId: Int64?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editActivityTitleLabel.text = controllerTitle

        if currentActivityId != nil {
            presentEditActivityView()
        }
    }

    func presentEditActivityView() {
        let currentActivity = Model.selectActivityById(currentActivityId!)
        
        setTime(.estimated, minutes: Int(currentActivity.activityEstimatedTime))
        setTime(.scheduled, minutes: Int(currentActivity.activityScheduledTime))
        setTime(.real, minutes: Int(currentActivity.activityRealTime))
        
        activityName.text = currentActivity.activityName
        activityDescription.text = currentActivity.description
        
        activityHasScheduledTime.isOn = currentActivity.activityScheduledTime != 0 ? true : false
    }
    
    func storeActivityData() {
        var newActivityId: Int64 = 0
        let estimatedTime = calculateTime(.estimated)
        let scheduledTime = calculateTime(.scheduled)
        let realTime = calculateTime(.real)
    
        if let previousActivity = Model.selectAllActivities(orderedBy: "idActivity").first {
            newActivityId = previousActivity.idActivity + 1
        }
        
        
        
        Model.createRecordInDatabase(id: newActivityId, name: activityName.text!, description: activityDescription.text!, estimatedTime: estimatedTime, scheduledTime: activityHasScheduledTime.isOn ? scheduledTime : 0, realTime: realTime, isTerminated: false)
    }
    
    func updateActivityData(terminateActivity: Bool) {
        let estimatedTime = calculateTime(.estimated)
        let scheduledTime = calculateTime(.scheduled)
        let realTime = calculateTime(.real)
        
        Model.updateRecordInDatabase(id: currentActivityId!, name: activityName.text!, description: activityDescription.text!, estimatedTime: estimatedTime, scheduledTime: scheduledTime, realTime: realTime, isTerminated: terminateActivity)
    }
    
    func calculateTime(_ time: Time) -> Int64 {
        var timeComponents: DateComponents
        var totalTime: Int64
        
        switch time {
        case .estimated:
            timeComponents = Calendar.current.dateComponents([.hour, .minute], from: activityEstimatedTime.date)
        case .scheduled:
            timeComponents = Calendar.current.dateComponents([.hour, .minute], from: activityScheduledTime.date)
        case .real:
            timeComponents = Calendar.current.dateComponents([.hour, .minute], from: activityRealTime.date)
        }
        
        totalTime = Int64(timeComponents.hour! * 60 + timeComponents.minute!)
        
        return totalTime
    }
    
    func setTime(_ time: Time, minutes: Int = 0) {
        var timeComponents: DateComponents = DateComponents()
        timeComponents.hour = minutes / 60
        timeComponents.minute = minutes % 60
       
        switch time {
        case .estimated:
            activityEstimatedTime.setDate(Calendar.current.date(from: timeComponents)!, animated: false)
        case .scheduled:
            activityScheduledTime.setDate(Calendar.current.date(from: timeComponents)!, animated: false)
        case .real:
            activityRealTime.setDate(Calendar.current.date(from: timeComponents)!, animated: false)
        }
    }
    
    func navigateToHome() {
        
    }
    
    // Dismisses keyboard when the user touches outside of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    enum Time {
        case estimated
        case scheduled
        case real
    }
}

