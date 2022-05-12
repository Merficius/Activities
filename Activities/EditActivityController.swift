import UIKit

class EditActivityController: UIViewController {
    @IBOutlet var activityName: UITextField!
    @IBOutlet var activityDescription: UITextView!
    @IBOutlet var activityEstimatedTime: UIDatePicker!
    @IBOutlet var activityHasScheduledTime: UISwitch!
    @IBOutlet var activityScheduledTime: UIDatePicker!
    @IBOutlet var activityRealTime: UIDatePicker!
    @IBOutlet var activityRealTimeLabel: UILabel!
    @IBOutlet var editActivityTitleLabel: UILabel!
    @IBOutlet var endActivityButton: UIButton!
    @IBOutlet var deleteActivityButton: UIButton!
    
    var controllerTitle: String = ""
    var endActivityButtonIsHidden = false
    var currentCellIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        editActivityTitleLabel.text = controllerTitle
        
        if endActivityButtonIsHidden {
            endActivityButton.isHidden = true
            editActivityTitleLabel.textAlignment = .left
            activityRealTime.isHidden = true
            activityRealTimeLabel.isHidden = true
            deleteActivityButton.isHidden = true
        }

        if Model.currentActivityId != nil {
            presentEditActivityView()
        }
    }

    func presentEditActivityView() {
        let currentActivity = Model.selectActivityById(Model.currentActivityId!)
        
        setTime(.estimated, seconds: Int(currentActivity.activityEstimatedTime))
        setTime(.scheduled, seconds: Int(currentActivity.activityScheduledTime))
        setTime(.real, seconds: Int(currentActivity.activityRealTime))
        
        activityName.text = currentActivity.activityName

        activityDescription.text = currentActivity.activityDescription
        
        activityHasScheduledTime.isOn = currentActivity.activityScheduledTime != -1 ? true : false
    }
    
    func storeActivityData() {
        var newActivityId: Int64 = 0
        let estimatedTime = calculateTime(.estimated)
        let scheduledTime = calculateTime(.scheduled)
        let realTime = calculateTime(.real)
    
        if let previousActivity = Model.selectAllActivities(orderedBy: "idActivity").first {
            newActivityId = previousActivity.idActivity + 1
        }
        
        Model.createRecordInDatabase(id: newActivityId, name: activityName.text!, description: activityDescription.text!, estimatedTime: estimatedTime, scheduledTime: activityHasScheduledTime.isOn ? scheduledTime : -1, realTime: realTime, isTerminated: false)
    }
    
    func updateActivityData(terminateActivity: Bool) {
        let estimatedTime = calculateTime(.estimated)
        let scheduledTime = calculateTime(.scheduled)
        let realTime = calculateTime(.real)
        
        Model.updateRecordInDatabase(id: Model.currentActivityId!, name: activityName.text!, description: activityDescription.text!, estimatedTime: estimatedTime, scheduledTime: scheduledTime, realTime: realTime, isTerminated: terminateActivity)
    }
    
    // Calculation about the time displayed
    func calculateTime(_ time: Time) -> Int64 {
        var timeComponents: DateComponents
        var totalTime: Int64
        
        switch time {
        case .estimated:
            timeComponents = Calendar.current.dateComponents([.hour, .minute], from: activityEstimatedTime.date)
            timeComponents.second = 0
        case .scheduled:
            timeComponents = Calendar.current.dateComponents([.hour, .minute], from: activityScheduledTime.date)
            timeComponents.second = 0
        case .real:
            timeComponents = Calendar.current.dateComponents([.hour, .minute], from: activityRealTime.date)
            if endActivityButtonIsHidden {
                timeComponents.hour = 0
                timeComponents.minute = 0
                timeComponents.second = 0
            } else {
                timeComponents.second = Int(Model.selectActivityById(Model.currentActivityId!).activityRealTime % 60)
            }
        }
        
        totalTime = Int64(timeComponents.hour! * 3600 + timeComponents.minute! * 60 + timeComponents.second!)
        
        return totalTime
    }
    
    func setTime(_ time: Time, seconds: Int = 0) {
        var timeComponents: DateComponents = DateComponents()
        timeComponents.hour = seconds / 3600 % 24
        timeComponents.minute = seconds / 60 % 60
       
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
    
    @IBAction func deleteActivity(_ sender: UIButton) {
        Model.deleteFromActivities(withId: Model.currentActivityId!)
    }
    
    enum Time {
        case estimated
        case scheduled
        case real
    }
}

