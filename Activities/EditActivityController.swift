import UIKit

class EditActivityController: UIViewController {
    @IBOutlet weak var activityName: UITextField!
    @IBOutlet weak var activityDescription: UITextView!
    @IBOutlet weak var activityEstimatedTime: UIDatePicker!
    @IBOutlet weak var activityHasScheduledTime: UISwitch!
    @IBOutlet weak var activityScheduledTime: UIDatePicker!
    @IBOutlet weak var activityRealTime: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func presentEditActivityView() {
        
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

