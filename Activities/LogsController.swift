import UIKit

class LogsController: UIViewController {

    @IBOutlet var LogsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating the nib that holds the LogsTableViewCell.xib file
        let nib = UINib(nibName: "LogsTableViewCell", bundle: nil)
        
        // Registers the custom nib so that we can use it in our tableview
        LogsTableView.register(nib, forCellReuseIdentifier: "LogsTableViewCell")
        
        // Assigns the datasource to itself
        LogsTableView.dataSource = self
    }

    func readTerminatedActivities() {
        
    }
    
    func presentLogsView() {
        
    }
    
    func navigateToHomeView() {
        
    }
}

extension LogsController: UITableViewDataSource {
    
    // Specifies which cell is going to use and selects the data that is going to fill
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogsTableViewCell", for: indexPath) as! LogsTableViewCell
        
        return cell
    }
    
    // Returns the number of cells wanted
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
