
import UIKit

protocol EditViewControllerDelegate: class {
    func editViewController(_ editController: EditViewController, didChange user: User)
    func editViewController(_ editController: EditViewController, didCompare user: User) -> Bool
}

class EditViewController: UITableViewController {
    
    private var user: User
    
    weak var delegate: EditViewControllerDelegate?
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "VC Edit"
        
        self.tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "TextCell")
        self.tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: "DatePickerCell")
        self.tableView.register(GenderPickerViewCell.self, forCellReuseIdentifier: "GenderPickerView")
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        tableView.reloadData()
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTouch))
        rightBarButton.title = "Save"
        print("tapSaveButton")
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func saveButtonTouch() {
        if user.name == "" || user.surName == "" {
            let alertController = UIAlertController(title: "No Data!", message: "Please enter you name and surname.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ок", style: .cancel))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            delegate?.editViewController(self, didChange: user)
            navigationController?.popViewController(animated: true)
        }
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
            (cell as? TextTableViewCell)?.delegate = self
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as? DatePickerTableViewCell
            (cell as? DatePickerTableViewCell)?.delegate = self
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "GenderPickerView", for: indexPath) as? GenderPickerViewCell
            (cell as? GenderPickerViewCell)?.delegate = self
        default:
            cell = UITableViewCell() as? TableViewCellProtocol
        }
        
        guard let attribute = user[indexPath] else {
            return UITableViewCell()
        }
        
        cell?.fill(title: attribute.description, data: user[attribute])
        
        guard let returnCell = cell else {
            print("cell is nil")
            return UITableViewCell()
        }
        return returnCell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension EditViewController: TextTableViewCellDelegate {
    func textTableViewCell(_ textCell: TextTableViewCell, didTextChange value: String) {
        guard let indexPath = tableView.indexPath(for: textCell), let attribute = user[indexPath] else { return }
        user[attribute] = value
    }
}

extension EditViewController: DatePickerTableViewCellDelegate {
    func datePickerTableViewCell(_ datePickerCell: DatePickerTableViewCell, didDateChange value: Date) {
        user.birthDate = value
    }
}

extension EditViewController: GenderPickerViewCellDelegate {
    func genderPickerViewCell(_ genderPickerCell: GenderPickerViewCell, didGenderChange value: User.Gender) {
        user.gender = value
    }
}
