
import UIKit

protocol GenderPickerViewCellDelegate: class {
    func genderPickerViewCell(_ genderPickerCell: GenderPickerViewCell, didGenderChange value: User.Gender)
}

class GenderPickerViewCell: UITableViewCell, TableViewCellProtocol {

    private let titleLabel = UILabel(frame: CGRect(x: 16, y: 11, width: 140, height: 21))
    private let descriptionLabel = UILabel(frame: CGRect(x: 164, y: 11, width: 140, height: 21))
    private let pickerView = UIPickerView(frame: CGRect(x: 164, y: 0, width: 140, height: 44))
    private let editTextField = UITextField(frame: CGRect(x: 16, y: 11, width: 14, height: 21))
    
    weak var delegate: GenderPickerViewCellDelegate?
	
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
		
		
		pickerView.translatesAutoresizingMaskIntoConstraints = false
		pickerView.delegate = self
		pickerView.dataSource = self
		
	
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	func fill(title: String, data: Any?) {
        setupTitleLable(text: title)
		titleLabel.text = title
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    func setupTitleLable(text: String) {
        titleLabel.text = text
        titleLabel.textAlignment = .left
        self.contentView.addSubview(titleLabel)
    }
    
    func setupGenderPickerView(gender: User.Gender) {
        pickerView.delegate = self
        pickerView.dataSource = self

        
        switch gender {
        case .none:
			pickerView.selectRow(0, inComponent: 0, animated: false)
        case .man:
            pickerView.selectRow(1, inComponent: 0, animated: false)
        case .woman:
            pickerView.selectRow(2, inComponent: 0, animated: false)
        }
        
        self.contentView.addSubview(pickerView)
    }
	
	
}

extension GenderPickerViewCell: UIPickerViewDataSource{
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		   return 1
	   }
	   
	   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		   return User.Gender.allCases.count
	   }
	   
	   func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		   return 44
	   }
	   
	   func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		   
		   guard (view as? UILabel) != nil else {
			   let pickerLabel = UILabel()
			   pickerLabel.font = UIFont.systemFont(ofSize: 20)
			   pickerLabel.textAlignment = .center
			   pickerLabel.text = User.Gender.allCases[row].description
			   return pickerLabel
		   }
		   
		   return UILabel()
	   }
}

extension GenderPickerViewCell: UIPickerViewDelegate{
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.genderPickerViewCell(self, didGenderChange: User.Gender.allCases[row])
    }
}
extension GenderPickerViewCell: UITextFieldDelegate{
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
		return false
	}
	func textFieldShouldBeginEditing(_ sender: UITextField) -> Bool {
		sender.inputView = pickerView
		return true; //do not show keyboard nor cursor
	}
}
