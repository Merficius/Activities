import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var activitiesTableView: UITableView!
    var cellsLoadedForTheFirstTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.initialize()
        
        let nib = UINib(nibName: "ActivitiesTableViewCell", bundle: nil)
        activitiesTableView.register(nib, forCellReuseIdentifier: "ActivitiesTableViewCell")
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        //        Model.deleteAllActivities()
    }
    
    // Executed each time that the view is placed in the hierarchy (more often than viewDidLoad)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readNotTerminatedActivities()
    }
    
    func readNotTerminatedActivities() {
        Model.notTerminatedActivities = Model.selectAllNotTerminatedActivities()
        
        presentHomeView()
    }
    
    func presentHomeView() {
        activitiesTableView.reloadData()
    }
    
    func startTimer(_ sender: UIButton) {
        Model.scheduledTimers[sender.tag] = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel(sender:)), userInfo: sender.tag, repeats: true)
    }
    
    func stopTimer(_ sender: UIButton) {
        if let removedTimer = Model.scheduledTimers.removeValue(forKey: sender.tag) {
            removedTimer.invalidate()
        }
    }
    
    @objc func updateTimerLabel(sender: Timer) {
        Model.notTerminatedActivities[sender.userInfo as! Int].activityRealTime += 1
        presentHomeView()
        Model.save()
    }
    
    func stopTimer(indexRow: Int) {
        if let removedTimer = Model.scheduledTimers.removeValue(forKey: indexRow) {
            removedTimer.invalidate()
        }
    }
    
    // Preparing to navigate to editActivityController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let editActivityController = segue.destination as? EditActivityController else { return }
        
        if let _ = sender as? UIButton {
            // If the sender is a button then it is a new activity
            editActivityController.controllerTitle = "New Activity"
            editActivityController.endActivityButtonIsHidden = true
        } else if let sender = sender as? UITableView {
            // if the sender is a tableview then it is an edit activity
            editActivityController.controllerTitle = "Edit Activity"
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
        
        cell.ActivityNameLabel.text = currentCellActivity.activityName
        
        //calculates time for string
        var calculatedString = ""
        let seconds = currentCellActivity.activityRealTime
        calculatedString += String(format: "%02d:", seconds / 3600 % 24)
        calculatedString += String(format: "%02d:", seconds / 60 % 60)
        calculatedString += String(format: "%02d", seconds % 60)
        cell.ActivityDurationLabel.text = calculatedString
        
        // Allows to perform a function when the button of a cell is tapped
        cell.ActivityControlButton.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.ActivityControlButton.tag = indexPath.row
        
        // Changing appearance of button
        if currentCellActivity.timerIsCounting {
            cell.ActivityControlButton.setImage(UIImage(systemName: "stop"), for: .normal)
            cell.ActivityControlButton.tintColor = UIColor.systemRed
            
            if !cellsLoadedForTheFirstTime {
                startTimer(cell.ActivityControlButton)
            }
        } else {
            cell.ActivityControlButton.setImage(UIImage(systemName: "play"), for: .normal)
            cell.ActivityControlButton.tintColor = UIColor.systemGreen
        }
        
        if indexPath.row == Model.notTerminatedActivities.count - 1 {
            // Assigns true at the end of constructing the last cell
            cellsLoadedForTheFirstTime = true
        }
        
        return cell
    }
    
    // Function that the button does when tapped
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
        var timerIsCounting = Model.notTerminatedActivities[buttonTag].timerIsCounting
        
        timerIsCounting.toggle()
        timerIsCounting ? startTimer(sender) : stopTimer(sender)
        
        Model.save()
        
        presentHomeView()
    }
}
