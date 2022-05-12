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
    
    // Used to stop timers when unwinding
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

    // Fills the data for the already created activity
    func presentEditActivityView() {
        guard let currentActivity = Model.currentActivity else { return }
        
        activityNameTextField.text = currentActivity.activityName

        activityDescriptionTextView.text = currentActivity.activityDescription
        
        setTimeForPicker(.estimated, seconds: Int(currentActivity.activityEstimatedTime))
        
        activityHasScheduledTimeSwitch.isOn = currentActivity.activityScheduledTime != -1 ? true : false
        setTimeForPicker(.scheduled, seconds: Int(currentActivity.activityScheduledTime))
        
        setTimeForPicker(.real, seconds: Int(currentActivity.activityRealTime))
    }
    
    // Sets dates for date pickers based on seconds
    func setTimeForPicker(_ datePickerType: DatePickerType, seconds: Int = 0) {
        var timeComponents: DateComponents = DateComponents()
        let modulusTime = Model.calculateModulusTime(seconds: seconds)
        
        timeComponents.hour = modulusTime.hours
        timeComponents.minute = modulusTime.minutes
       
        switch datePickerType {
        case .estimated:
            activityEstimatedTimeDatePicker.setDate(Calendar.current.date(from: timeComponents)!, animated: false)
        case .scheduled:
            activityScheduledTimeDatePicker.setDate(Calendar.current.date(from: timeComponents)!, animated: false)
        case .real:
            activityRealTimeDatePicker.setDate(Calendar.current.date(from: timeComponents)!, animated: false)
        }
    }
    
    // Stores the created activity (.newActivity) in the database
    func storeActivityData() {
        var newActivityId: Int64 = 0
        let estimatedTime = getTimeFrom(picker: .estimated)
        let scheduledTime = getTimeFrom(picker: .scheduled)
        let realTime = getTimeFrom(picker: .real)
    
        if let previousActivity = Model.selectAllActivities(orderedBy: "idActivity").first {
            newActivityId = previousActivity.idActivity + 1
        }
        
        Model.createRecordInDatabase(id: newActivityId, name: activityNameTextField.text!, description: activityDescriptionTextView.text!, estimatedTime: estimatedTime, scheduledTime: activityHasScheduledTimeSwitch.isOn ? scheduledTime : -1, realTime: realTime, isTerminated: false)
    }
    
    // Gets the time in seconds from the given picker
    func getTimeFrom(picker: DatePickerType) -> Int64 {
        var timeComponents: DateComponents
        var totalTime: Int64
        let timeComponentsTuple: (hours: Int, minutes: Int, seconds: Int)
        
        switch picker {
        case .estimated:
            // .second will always be 0 in picker
            timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: activityEstimatedTimeDatePicker.date)
        case .scheduled:
            // .second will always be 0 in picker
            timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: activityScheduledTimeDatePicker.date)
        case .real:
            // .second will always be 0 in picker
            timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: activityRealTimeDatePicker.date)
            
            if controllerType == .newActivity {
                timeComponents.hour = 0
                timeComponents.minute = 0
                timeComponents.second = 0
            } else {
                let currentActivityRealTime = Int(Model.currentActivity!.activityRealTime)
                timeComponents.second = Model.calculateModulusTime(seconds: currentActivityRealTime).seconds
            }
        }
        
        timeComponentsTuple = (timeComponents.hour!, timeComponents.minute!, timeComponents.second!)
        totalTime = Int64(Model.calculateTotalTime(from: timeComponentsTuple))
        
        return totalTime
    }
    
    func updateActivityData(terminateActivity: Bool) {
        let estimatedTime = getTimeFrom(picker: .estimated)
        let scheduledTime = getTimeFrom(picker: .scheduled)
        let realTime = getTimeFrom(picker: .real)
        
        Model.updateRecordInDatabase(id: Model.currentActivityId!, name: activityNameTextField.text!, description: activityDescriptionTextView.text!, estimatedTime: estimatedTime, scheduledTime: scheduledTime, realTime: realTime, isTerminated: terminateActivity)
    }
    
    // Used in tabbar
    func navigateToHome() {
        
    }
    
    @IBAction func deleteActivity(_ sender: UIButton) {
        Model.deleteFromActivities(withId: Model.currentActivityId!)
    }
    
    enum DatePickerType {
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

