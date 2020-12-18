

import UIKit

protocol TableViewCellProtocol: UITableViewCell {
    func fill(title: String, data: Any?)
}

class PreviewViewController: UITableViewController {
    
    private var user: User?

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        
        self.tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "TextCell")
        self.tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: "DatePickerCell")
        self.tableView.register(GenderPickerViewCell.self, forCellReuseIdentifier: "GenderPickerView")
        self.tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editButtonTouchUp))
    }
    
    @objc func editButtonTouchUp(){
    let viewController = EditViewController(user: user?.copy() ?? User())
    viewController.delegate = self
    print("tapEditButton")
    navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.FieldsTypes.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TableViewCellProtocol?
        
        switch indexPath.row {
        case 0...1:
            cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as? TextTableViewCell
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as? DatePickerTableViewCell
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "GenderPickerView", for: indexPath) as? GenderPickerViewCell
        default:
            cell = UITableViewCell() as? TableViewCellProtocol
        }
        
        guard let attribute = user?[indexPath] else {
            return UITableViewCell()
        }
        cell?.fill(title: attribute.description, data:user?[attribute])
        
        guard let returnCell = cell else {
            print("cell is nil")
            return UITableViewCell()
        }
        return returnCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    init() {
        do {
            self.user = try User.load()
            print("User information is load")
        } catch User.loadError.noData {
            print("Load error(No Data)")
        } catch User.loadError.decodeError {
            print("Load error(Decode Error)")
        } catch {
            print(error)
        }
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PreviewViewController: EditViewControllerDelegate {
    func editViewController(_ editView: EditViewController, didChange user: User) {
        self.user = user
        if self.user?.save() == true {
            print("Update")
        }
    }
    
    func editViewController(_ editView: EditViewController, didCompare user: User) -> Bool {
        guard let tmUser = self.user else { return false }
        return tmUser == user
    }
}
