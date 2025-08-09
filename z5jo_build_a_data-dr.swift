import UIKit
import SwiftForms

class AutomationScriptDashboardController: UIViewController {
    let tableView = UITableView()
    let dataStore = AutomationScriptDataStore()
    var automationScripts: [AutomationScript] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadAutomationScripts()
    }

    func loadAutomationScripts() {
        dataStore.fetchAutomationScripts { [weak self] scripts in
            self?.automationScripts = scripts
            self?.tableView.reloadData()
        }
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AutomationScriptCell.self, forCellReuseIdentifier: "AutomationScriptCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension AutomationScriptDashboardController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return automationScripts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutomationScriptCell", for: indexPath) as! AutomationScriptCell
        let script = automationScripts[indexPath.row]
        cell.scriptNameLabel.text = script.name
        cell.scriptDescriptionLabel.text = script.description
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let script = automationScripts[indexPath.row]
        // Run the automation script
        dataStore.runAutomationScript(script) { result in
            if result {
                print("Automation script \(script.name) completed successfully")
            } else {
                print("Error running automation script \(script.name)")
            }
        }
    }
}

class AutomationScriptCell: UITableViewCell {
    let scriptNameLabel = UILabel()
    let scriptDescriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLabels() {
        scriptNameLabel.translatesAutoresizingMaskIntoConstraints = false
        scriptDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scriptNameLabel)
        contentView.addSubview(scriptDescriptionLabel)
        scriptNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        scriptNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        scriptDescriptionLabel.topAnchor.constraint(equalTo: scriptNameLabel.bottomAnchor, constant: 4).isActive = true
        scriptDescriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
    }
}

class AutomationScriptDataStore {
    func fetchAutomationScripts(completion: ([AutomationScript]) -> Void) {
        // Implement data fetching logic here
        let scripts: [AutomationScript] = [
            AutomationScript(name: "Script 1", description: "This is script 1"),
            AutomationScript(name: "Script 2", description: "This is script 2"),
            AutomationScript(name: "Script 3", description: "This is script 3")
        ]
        completion(scripts)
    }

    func runAutomationScript(_ script: AutomationScript, completion: (Bool) -> Void) {
        // Implement automation script running logic here
        print("Running automation script \(script.name)")
        completion(true)
    }
}

struct AutomationScript {
    let name: String
    let description: String
}