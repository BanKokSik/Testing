
import UIKit

protocol DatePickerTableViewCellDelegate: class {
	func datePickerTableViewCell(_ datePickerCell: DatePickerTableViewCell, didDateChange value: Date)
}

class DatePickerTableViewCell: UITableViewCell, TableViewCellProtocol {
	
	let titleLabel = UILabel(frame: CGRect(x: 16, y: 11, width: 140, height: 21))
	let editTextField = UITextField(frame: CGRect(x: 16, y: 11, width: 14, height: 21))
	
	let datePicker = UIDatePicker()
	let dateFormatter = DateFormatter()
	
	weak var delegate: DatePickerTableViewCellDelegate?
	
	
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
		//editTextField.delegate = self
		//editTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
		editTextField.translatesAutoresizingMaskIntoConstraints = false
		editTextField.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 20).isActive = true
		//editTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 76).isActive = true
		contentView.trailingAnchor.constraint(equalTo: editTextField.trailingAnchor, constant: 16).isActive = true
		editTextField.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
		editTextField.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor, constant: 0).isActive = true
		editTextField.delegate = self
		
		
		datePicker.datePickerMode = .date
		datePicker.minimumDate = dateFormatter.date(from: "01.01.1930")
		datePicker.maximumDate = Date()
		datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
	func fill(title: String, data: Any?) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yyyy"
		
		titleLabel.text = title
		if let value = data as? Date {
			editTextField.text = dateFormatter.string(from: value)
		}
		
		self.selectionStyle = UITableViewCell.SelectionStyle.none
	}
	
	func setupTitleLable(text: String) {
		titleLabel.text = text
		titleLabel.textAlignment = .left
		self.contentView.addSubview(titleLabel)
		setTitleLabel()
	}
	
	
	
	
	func setupDatePicker(date: Date) {
		datePicker.datePickerMode = .date
		datePicker.setDate(date, animated: true)
		datePicker.minimumDate = dateFormatter.date(from: "01.01.1900")
		datePicker.maximumDate = Date()
		datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
		self.contentView.addSubview(datePicker)
		setDatePicker()
		
	}
	
	@objc func datePickerValueChanged(sender: UIDatePicker) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yyyy"
		editTextField.text = dateFormatter.string(from: sender.date)
	}
	
	
	func setTitleLabel() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
		titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 11).isActive = true
	}
	
	
	
	func setDatePicker() {
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor, constant: 0).isActive = true
		self.contentView.bottomAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 0).isActive = true
		datePicker.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40).isActive = true
		datePicker.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
		datePicker.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 0).isActive = true
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
}

extension DatePickerTableViewCell: UITextFieldDelegate{
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
		return false
	}
	func textFieldShouldBeginEditing(_ sender: UITextField) -> Bool {
		sender.inputView = datePicker
		return true; //do not show keyboard nor cursor
	}
}
