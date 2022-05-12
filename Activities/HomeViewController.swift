import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var activitiesTableView: UITableView!
    var currentIndex: Int64 = 0
    var scheduledTimers = [Int: Timer]()
    var isInitialized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.initialize()
        readNotTerminatedActivities()
        
        let nib = UINib(nibName: "ActivitiesTableViewCell", bundle: nil)
        activitiesTableView.register(nib, forCellReuseIdentifier: "ActivitiesTableViewCell")
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
//                Model.deleteAllFromUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readNotTerminatedActivities()
    }
    
    @IBAction func navigateToEditActivity(_ sender: UIButton) {
        performSegue(withIdentifier: "NewActivity", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let editActivityController = segue.destination as? EditActivityController else { return }
        
        if let _ = sender as? UIButton {
            editActivityController.controllerTitle = "New Activity"
            editActivityController.endActivityButtonIsHidden = true
        } else if let sender = sender as? UITableView {
            editActivityController.controllerTitle = "Edit Activity"
            editActivityController.currentActivityId = currentIndex
            editActivityController.currentCellIndex = sender.indexPathForSelectedRow
        }
    }
    
    func presentHomeView() {
        
    }
    
    func startTimer(_ sender: UIButton) {
        scheduledTimers[sender.tag] = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel(sender:)), userInfo: sender.tag, repeats: true)
    }
    
    @objc func updateTimerLabel(sender: Timer) {
        Model.notTerminatedActivities[sender.userInfo as! Int].activityRealTime += 1
        activitiesTableView.reloadData()
        Model.save()
        print(scheduledTimers.keys)
    }
    
    func stopTimer(_ sender: UIButton) {
        if let removedTimer = scheduledTimers.removeValue(forKey: sender.tag) {
            removedTimer.invalidate()
        }
    }
    
    func stopTimer(indexRow: Int) {
        if let removedTimer = scheduledTimers.removeValue(forKey: indexRow) {
            removedTimer.invalidate()
        }
    }
    
    func navigateToLogs() {
        
    }
    
    func readNotTerminatedActivities() {
        Model.selectAllNotTerminatedActivities()
        
        activitiesTableView.reloadData()
    }
    
    // Used when the user taps the done button
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue) {
        if let editActivityController = unwindSegue.source as? EditActivityController {
            
            if editActivityController.editActivityTitleLabel.text == "Edit Activity" {
                editActivityController.updateActivityData(terminateActivity: false)
            } else if editActivityController.editActivityTitleLabel.text == "New Activity" {
                editActivityController.storeActivityData()
            }
            //            print(Model.selectAllActivities(orderedBy: "idActivity"))
        }
    }
    
    // Used when the user taps the end activity button
    @IBAction func endActivityUnwind(unwindSegue: UIStoryboardSegue) {
        if let editActivityController = unwindSegue.source as? EditActivityController {
            editActivityController.updateActivityData(terminateActivity: true)
            stopTimer(indexRow: editActivityController.currentCellIndex!.row)
            //            print(Model.selectAllActivities(orderedBy: "idActivity"))
        }
    }
    
    @IBAction func unwindWhenDeleted(unwindSegue: UIStoryboardSegue) {
        if let editActivityController = unwindSegue.source as? EditActivityController {
            stopTimer(indexRow: editActivityController.currentCellIndex!.row)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = Model.notTerminatedActivities[indexPath.row].idActivity
        
        // Deselects the row and performs the segue to EditActivityController
        performSegue(withIdentifier: "EditActivity", sender: tableView)
        activitiesTableView.deselectRow(at: indexPath, animated: false)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.notTerminatedActivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = activitiesTableView.dequeueReusableCell(withIdentifier: "ActivitiesTableViewCell", for: indexPath) as! ActivitiesTableViewCell
        
        cell.ActivityNameLabel.text = Model.notTerminatedActivities[indexPath.row].activityName
        cell.ActivityDurationLabel.text = String(Model.notTerminatedActivities[indexPath.row].activityRealTime)
        
        // Allows to perform a function when the button of a cell is tapped
        cell.ActivityControlButton.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.ActivityControlButton.tag = indexPath.row
        
        // Changing appearance of button
        if Model.notTerminatedActivities[indexPath.row].timerIsCounting {
            cell.ActivityControlButton.setImage(UIImage(systemName: "stop"), for: .normal)
            cell.ActivityControlButton.tintColor = UIColor.systemRed
            
            if !isInitialized {
                startTimer(cell.ActivityControlButton)
            }
        } else {
            cell.ActivityControlButton.setImage(UIImage(systemName: "play"), for: .normal)
            cell.ActivityControlButton.tintColor = UIColor.systemGreen
        }
        
        if indexPath.row == Model.notTerminatedActivities.count - 1 {
            print(indexPath.row, Model.notTerminatedActivities.count - 1)
            // Assigns true at the end of constructing all the cells
            isInitialized = true
        }
        
        return cell
    }
    
    // Function that the button does when tapped
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
        
        Model.notTerminatedActivities[buttonTag].timerIsCounting.toggle()
        Model.notTerminatedActivities[buttonTag].timerIsCounting ? startTimer(sender) : stopTimer(sender)
        Model.save()
        
        activitiesTableView.reloadData()
    }
}
