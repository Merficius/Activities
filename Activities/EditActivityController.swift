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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentEditActivityView()
    }

    func presentEditActivityView() {
        editActivityTitleLabel.text = controllerTitle
    }
    
    func storeActivityData() {
        var newActivityId: Int64 = 0
        let estimatedTime = calculateTime(.estimated)
        let scheduledTime = calculateTime(.scheduled)
        let realTime = calculateTime(.real)
    
        if let previousActivity = Model.selectAllActivities(orderedBy: "idActivity").first {
            newActivityId = previousActivity.idActivity + 1
        }
        
        Model.createRecordInDatabase(id: newActivityId, name: activityName.text!, description: activityDescription.text!, estimatedTime: estimatedTime, scheduledTime: scheduledTime, realTime: realTime, isTerminated: true)
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

