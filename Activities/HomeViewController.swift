import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var activitiesTableView: UITableView!
    var cellIsLoadedForTheFirstTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.initialize()
        
        // Register the nib file so that we can use it to construct our cells
        let nib = UINib(nibName: "ActivitiesTableViewCell", bundle: nil)
        activitiesTableView.register(nib, forCellReuseIdentifier: "ActivitiesTableViewCell")
        
        // Establishing the delegate and datasource of tableview to be this controller
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        //        Model.deleteAllActivities()
    }
    
    // Executed each time that the view is placed in the hierarchy (more often than viewDidLoad)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentHomeView()
    }
    
    func presentHomeView() {
        readNotTerminatedActivities()
        activitiesTableView.reloadData()
    }
    
    func readNotTerminatedActivities() {
        Model.notTerminatedActivities = Model.selectAllNotTerminatedActivities()
    }
    
    func startTimer(_ sender: UIButton) {
        let buttonTag = sender.tag
        
        Model.scheduledTimers[buttonTag] = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(increaseRealTime(sender:)), userInfo: buttonTag, repeats: true)
    }
    
    func stopTimer(_ sender: UIButton) {
        let buttonTag = sender.tag
        
        if let removedTimer = Model.scheduledTimers.removeValue(forKey: buttonTag) {
            removedTimer.invalidate()
        }
    }
    
    // Used when deleting or ending activities
    func stopTimer(indexRow: Int) {
        if let removedTimer = Model.scheduledTimers.removeValue(forKey: indexRow) {
            removedTimer.invalidate()
        }
    }
    
    @objc func increaseRealTime(sender: Timer) {
        let buttonTag = sender.userInfo as! Int
        
        Model.notTerminatedActivities[buttonTag].activityRealTime += 1
        
        activitiesTableView.reloadData()
        
        Model.save()
    }
    
    // Preparing to navigate to editActivityController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let editActivityController = segue.destination as? EditActivityController else { return }
        
        if let _ = sender as? UIButton {
            // If the sender is a button then it is a new activity
            editActivityController.controllerType = .newActivity
        } else if let sender = sender as? UITableView {
            // if the sender is a tableview then it is an edit activity
            editActivityController.controllerType = .editActivity
            editActivityController.currentCellIndex = sender.indexPathForSelectedRow
        }
    }
    
    @IBAction func navigateToEditActivity(_ sender: Any) {
        if let _ = sender as? UIButton {
            performSegue(withIdentifier: "NewActivity", sender: sender)
        } else if let _ = sender as? UITableView {
            performSegue(withIdentifier: "EditActivity", sender: sender)
        }
    }
    
    // Used in tabbar
    func navigateToLogs() {
        
    }
    
    // Called when the user taps the done button
    @IBAction func unwindWhenDone(unwindSegue: UIStoryboardSegue) {
        if let editActivityController = unwindSegue.source as? EditActivityController {
            
            if editActivityController.editActivityTitleLabel.text == "Edit Activity" {
                editActivityController.updateActivityData(terminateActivity: false)
            } else if editActivityController.editActivityTitleLabel.text == "New Activity" {
                editActivityController.storeActivityData()
            }
        }
    }
    
    // Called when the user taps the end activity button
    @IBAction func unwindWhenEnded(unwindSegue: UIStoryboardSegue) {
        if let editActivityController = unwindSegue.source as? EditActivityController {
            editActivityController.updateActivityData(terminateActivity: true)
            stopTimer(indexRow: editActivityController.currentCellIndex!.row)
            //            print(Model.selectAllActivities(orderedBy: "idActivity"))
        }
    }
    
    // Called when the user taps the delete button
    @IBAction func unwindWhenDeleted(unwindSegue: UIStoryboardSegue) {
        if let editActivityController = unwindSegue.source as? EditActivityController {
            stopTimer(indexRow: editActivityController.currentCellIndex!.row)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    // Called when selection a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Assigns the current activity id to be the one selected
        Model.currentActivityId = Model.notTerminatedActivities[indexPath.row].idActivity
        
        // Deselects the row and performs the segue to EditActivityController
        navigateToEditActivity(tableView)
        activitiesTableView.deselectRow(at: indexPath, animated: false)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    // Specifies the number of cells for the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.notTerminatedActivities.count
    }
    
    // Fills the data for the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // returns a reusable cell for performance reasons
        let cell = activitiesTableView.dequeueReusableCell(withIdentifier: "ActivitiesTableViewCell", for: indexPath) as! ActivitiesTableViewCell
        let currentCellActivity = Model.notTerminatedActivities[indexPath.row]
        let currentCellControlButton: UIButton = cell.ActivityControlButton
        
        cell.ActivityNameLabel.text = currentCellActivity.activityName
        cell.ActivityDurationLabel.text = Model.calculateTimeString(for: currentCellActivity)
        
        // Allows to perform a function when the button of a cell is tapped
        currentCellControlButton.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        currentCellControlButton.tag = indexPath.row
        
        // Changing appearance of button
        if currentCellActivity.timerIsCounting {
            // If the play button is active
            currentCellControlButton.setImage(UIImage(systemName: "stop"), for: .normal)
            currentCellControlButton.tintColor = UIColor.systemRed
            
            // Used when we exit the app and then we come back
            if !cellIsLoadedForTheFirstTime {
                startTimer(currentCellControlButton)
            }
        } else {
            // If the stop button is active
            currentCellControlButton.setImage(UIImage(systemName: "play"), for: .normal)
            currentCellControlButton.tintColor = UIColor.systemGreen
        }
        
        if indexPath.row == Model.notTerminatedActivities.count - 1 {
            // Assigns true at the end of constructing the last cell
            cellIsLoadedForTheFirstTime = true
        }
        
        return cell
    }
    
    // Function that the button does when tapped
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
        let currentButtonActivity = Model.notTerminatedActivities[buttonTag]
        
        currentButtonActivity.timerIsCounting.toggle()
        currentButtonActivity.timerIsCounting ? startTimer(sender) : stopTimer(sender)
        
        Model.save()
        
        activitiesTableView.reloadData()
    }
}
