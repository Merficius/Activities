import UIKit

class LogsController: UIViewController {

    @IBOutlet var logsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating the nib that holds the LogsTableViewCell.xib file
        let nib = UINib(nibName: "LogsTableViewCell", bundle: nil)
        
        // Registers the custom nib so that we can use it in our tableview
        logsTableView.register(nib, forCellReuseIdentifier: "LogsTableViewCell")
        
        // Assigns the datasource to this controller
        logsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentLogsView()
    }
    
    func presentLogsView() {
        readTerminatedActivities()
        logsTableView.reloadData()
    }
    
    func readTerminatedActivities() {
        Model.terminatedActivities = Model.selectAllTerminatedActivities()
    }
    
    // Tabbar
    func navigateToHomeView() {
        
    }
}

extension LogsController: UITableViewDataSource {
    // Returns the number of cells to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.terminatedActivities.count
    }
    
    // Specifies which cell is going to use and selects the data that is going to fill
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // returns a reusable cell for performance reasons
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogsTableViewCell", for: indexPath) as! LogsTableViewCell
        let currentCellActivity = Model.terminatedActivities[indexPath.row]
        
        // Sets the according labels
        cell.LogsActivityNameLabel.text = currentCellActivity.activityName
        cell.LogsActivityDurationLabel.text = Model.calculateTimeString(for: currentCellActivity)
        cell.LogsActivityPercentageLabel.text = Model.calculatePercentage(ofSeconds: Double(currentCellActivity.activityRealTime))
        
        return cell
    }
}
