import UIKit

class EditActivityController: UIViewController {
    @IBOutlet var endActivityButton: UIButton!
    @IBOutlet var editActivityTitleLabel: UILabel!
    @IBOutlet var activityNameTextField: UITextField!
    @IBOutlet var activityDescriptionTextView: UITextView!
    @IBOutlet var activityEstimatedTimeDatePicker: UIDatePicker!
    @IBOutlet var activityHasScheduledTimeSwitch: UISwitch!
    @IBOutlet var activityScheduledTimeDatePicker: UIDatePicker!
    @IBOutlet var activityRealTimeLabel: UILabel!
    @IBOutlet var activityRealTimeDatePicker: UIDatePicker!
    @IBOutlet var deleteActivityButton: UIButton!
    
    var controllerType: ControllerType = .editActivity
    var controllerTitle: String = ""
    var endActivityButtonIsHidden = false
    var currentCellIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        editActivityTitleLabel.text = controllerType == .newActivity ? "New Activity" : "Edit Activity"
        
        if controllerType == .newActivity {
            endActivityButton.isHidden = true
            editActivityTitleLabel.textAlignment = .left
            
            activityRealTimeLabel.isHidden = true
            activityRealTimeDatePicker.isHidden = true
            
            deleteActivityButton.isHidden = true
        } else {
            presentEditActivityView()
        }
    }

    func presentEditActivityView() {
        let currentActivity = Model.selectActivityById(Model.currentActivityId!)
        
        setTime(.estimated, seconds: Int(currentActivity.activityEstimatedTime))
        setTime(.scheduled, seconds: Int(currentActivity.activityScheduledTime))
        setTime(.real, seconds: Int(currentActivity.activityRealTime))
        
        activityNameTextField.text = currentActivity.activityName

        activityDescriptionTextView.text = currentActivity.activityDescription
        
        activityHasScheduledTimeSwitch.isOn = currentActivity.activityScheduledTime != -1 ? true : false
    }
    
    func storeActivityData() {
        var newActivityId: Int64 = 0
        let estimatedTime = calculateTime(.estimated)
        let scheduledTime = calculateTime(.scheduled)
        let realTime = calculateTime(.real)
    
        if let previousActivity = Model.selectAllActivities(orderedBy: "idActivity").first {
            newActivityId = previousActivity.idActivity + 1
        }
        
        Model.createRecordInDatabase(id: newActivityId, name: activityNameTextField.text!, description: activityDescriptionTextView.text!, estimatedTime: estimatedTime, scheduledTime: activityHasScheduledTimeSwitch.isOn ? scheduledTime : -1, realTime: realTime, isTerminated: false)
    }
    
    func updateActivityData(terminateActivity: Bool) {
        let estimatedTime = calculateTime(.estimated)
        let scheduledTime = calculateTime(.scheduled)
        let realTime = calculateTime(.real)
        
        Model.updateRecordInDatabase(id: Model.currentActivityId!, name: activityNameTextField.text!, description: activityDescriptionTextView.text!, estimatedTime: estimatedTime, scheduledTime: scheduledTime, realTime: realTime, isTerminated: terminateActivity)
    }
    
    // Calculation about the time displayed
    func calculateTime(_ time: Time) -> Int64 {
        var timeComponents: DateComponents
        var totalTime: Int64
        
        switch time {
        case .estimated:
            timeComponents = Calendar.current.dateComponents([.hour, .minute], from: activityEstimatedTimeDatePicker.date)
            timeComponents.second = 0
        case .scheduled:
            timeComponents = Calendar.current.dateComponents([.hour, .minute], from: activityScheduledTimeDatePicker.date)
            timeComponents.second = 0
        case .real:
            timeComponents = Calendar.current.dateComponents([.hour, .minute], from: activityRealTimeDatePicker.date)
            if controllerType == .newActivity {
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
            activityEstimatedTimeDatePicker.setDate(Calendar.current.date(from: timeComponents)!, animated: false)
        case .scheduled:
            activityScheduledTimeDatePicker.setDate(Calendar.current.date(from: timeComponents)!, animated: false)
        case .real:
            activityRealTimeDatePicker.setDate(Calendar.current.date(from: timeComponents)!, animated: false)
        }
    }
    
    // Used in tabbar
    func navigateToHome() {
        
    }
    
    @IBAction func deleteActivity(_ sender: UIButton) {
        Model.deleteFromActivities(withId: Model.currentActivityId!)
    }
    
    enum Time {
        case estimated
        case scheduled
        case real
    }
    
    enum ControllerType {
        case newActivity
        case editActivity
    }
    
    // Dismisses keyboard when the user touches outside of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

