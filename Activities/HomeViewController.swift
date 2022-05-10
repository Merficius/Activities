import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var ActivitiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ActivitiesTableViewCell", bundle: nil)
        ActivitiesTableView.register(nib, forCellReuseIdentifier: "ActivitiesTableViewCell")
        ActivitiesTableView.delegate = self
        ActivitiesTableView.dataSource = self
    }
    
    func navigateToEditActivity() {
        
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
        Model.initialize()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselects the row and performs the segue to EditActivityController
        performSegue(withIdentifier: "EditActivity", sender: nil)
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
