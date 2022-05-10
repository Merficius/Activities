import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var ActivitiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.initialize()
        
        let nib = UINib(nibName: "ActivitiesTableViewCell", bundle: nil)
        ActivitiesTableView.register(nib, forCellReuseIdentifier: "ActivitiesTableViewCell")
        ActivitiesTableView.delegate = self
        ActivitiesTableView.dataSource = self
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
        
    }
    
    // Used when the user taps the done button
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue) {
        
        if let editActivityController = unwindSegue.source as? EditActivityController {
            editActivityController.storeActivityData()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselects the row and performs the segue to EditActivityController
        performSegue(withIdentifier: "EditActivity", sender: tableView)
        ActivitiesTableView.deselectRow(at: indexPath, animated: false)

    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ActivitiesTableView.dequeueReusableCell(withIdentifier: "ActivitiesTableViewCell", for: indexPath) as! ActivitiesTableViewCell
        
        return cell
    }
}
