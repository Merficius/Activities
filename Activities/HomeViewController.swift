import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var activitiesTableView: UITableView!
    var currentIndex: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.initialize()
        readNotTerminatedActivities()
        
        let nib = UINib(nibName: "ActivitiesTableViewCell", bundle: nil)
        activitiesTableView.register(nib, forCellReuseIdentifier: "ActivitiesTableViewCell")
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
//        Model.deleteAllFromUsers()
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
        } else if let _ = sender as? UITableView {
            editActivityController.controllerTitle = "Edit Activity"
            editActivityController.currentActivityId = currentIndex
        }
    }
    
    func presentHomeView() {
        
    }
    
    func startTimer() {
        
    }
    
    func stopTimer() {
        
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
//            print(Model.selectAllActivities(orderedBy: "idActivity"))
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
//        cell.ActivityControlButton.text = String(format: "%.1f", percentageDuration) + "%"
        
        return cell
    }
}
