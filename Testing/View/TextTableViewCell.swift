
import UIKit

protocol TextTableViewCellDelegate: class {
    func textTableViewCell(_ textCell: TextTableViewCell, didTextChange value: String)
}

class TextTableViewCell: UITableViewCell, UITextFieldDelegate, TableViewCellProtocol {
	
	
	private let titleLabel = UILabel(frame: CGRect(x: 16, y: 11, width: 14, height: 21))
	private let editTextField = UITextField(frame: CGRect(x: 16, y: 11, width: 14, height: 21))
	
	weak var delegate: TextTableViewCellDelegate?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
		
        
		titleLabel.textAlignment = .left
		self.contentView.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
		titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 11).isActive = true
		titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
		titleLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
		
		
		self.contentView.addSubview(editTextField)
		editTextField.textAlignment = .right
		editTextField.delegate = self
		editTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
		editTextField.translatesAutoresizingMaskIntoConstraints = false
		editTextField.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 20).isActive = true
		//editTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 76).isActive = true
		contentView.trailingAnchor.constraint(equalTo: editTextField.trailingAnchor, constant: 16).isActive = true
		editTextField.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
		editTextField.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor, constant: 0).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
	
	
	func fill(title: String, data: Any?) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yyyy"
		
		titleLabel.text = title
		if let value = data as? String{
			editTextField.text = value
		}
		
		self.selectionStyle = UITableViewCell.SelectionStyle.none
	}
	
	
	
	@objc func textFieldDidChange(sender: UITextField) {
		guard let convertDelegate = delegate else {
			print("delegate is nil")
			return
		}
		convertDelegate.textTableViewCell(self, didTextChange: sender.text!)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		textField.resignFirstResponder()
		return true
	}
	
}
