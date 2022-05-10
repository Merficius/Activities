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
            
    }
    
    func navigateToHome() {
        
    }
    
    // Dismisses keyboard when the user touches outside of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

