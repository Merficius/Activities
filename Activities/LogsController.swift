import UIKit

class LogsController: UIViewController {

    @IBOutlet var logsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating the nib that holds the LogsTableViewCell.xib file
        let nib = UINib(nibName: "LogsTableViewCell", bundle: nil)
        
        // Registers the custom nib so that we can use it in our tableview
        logsTableView.register(nib, forCellReuseIdentifier: "LogsTableViewCell")
        
        // Assigns the datasource to itself
        logsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readTerminatedActivities()
    }

    func readTerminatedActivities() {
        Model.terminatedActivities = Model.selectAllTerminatedActivities()
        logsTableView.reloadData()
    }
    
    func presentLogsView() {
        
    }
    
    func navigateToHomeView() {
        
    }
}

extension LogsController: UITableViewDataSource {
    
    // Specifies which cell is going to use and selects the data that is going to fill
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var percentageDuration: Double = Double(Model.terminatedActivities[indexPath.row].activityRealTime) * 100 / 86400
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogsTableViewCell", for: indexPath) as! LogsTableViewCell
        
        cell.LogsActivityNameLabel.text = Model.terminatedActivities[indexPath.row].activityName
        
        // Calculate string to display
        var calculatedString = ""
        let seconds = Model.terminatedActivities[indexPath.row].activityRealTime
        calculatedString += String(format: "%02d:", seconds / 3600 % 24)
        calculatedString += String(format: "%02d:", seconds / 60 % 60)
        calculatedString += String(format: "%02d", seconds % 60)
        cell.LogsActivityDurationLabel.text = calculatedString
        
        cell.LogsActivityPercentageLabel.text = String(format: "%.1f", percentageDuration) + "%"
        
        return cell
    }
    
    // Returns the number of cells wanted
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.terminatedActivities.count
    }
}
