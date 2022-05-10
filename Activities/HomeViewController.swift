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
    
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue) {
        
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello from activities home")
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
