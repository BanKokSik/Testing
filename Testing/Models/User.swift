import Foundation
import UIKit

class User: Codable {
	// MARK - Internal tyeps
	
    enum FieldsTypes: Int, CustomStringConvertible, CaseIterable {
        case name
        case surName
        case birthDate
        case gender
        
        var description: String{
            switch self {
            case .name:
                return "Name"
            case .surName:
                return "Surname"
            case .birthDate:
                return "Birth Date"
            case .gender:
                return "Gender"
            }
        }
    }
	
	enum Gender: Int, Codable, CustomStringConvertible, CaseIterable {
		case none = 0
		case man = 1
		case woman = 2
		
		var description: String{
			switch self {
			case .none:
				return "None"
			case .man:
				return "Man"
			case .woman:
				return "Woman"
			}
		}
	}
	
	// MARK - Properties
	
	var name : String
	var surName : String?
	var birthDate : Date?
	var gender : Gender = .none
	   	
    subscript (indexPath: IndexPath) -> FieldsTypes? {
		return FieldsTypes(rawValue: indexPath.row)
    }
	
    subscript (field: FieldsTypes) -> Any? {
        get {
            switch field {
            case .name:
                return self.name
            case .surName:
                return self.surName
            case .birthDate:
                return self.birthDate
            case .gender:
                return self.gender
            }
        }
        set(newValue) {
            switch field {
            case .name:
                self.name = newValue as? String ?? String()
            case .surName:
                self.surName = newValue as? String
            case .birthDate:
                self.birthDate = newValue as? Date
            case .gender:
                self.gender = newValue as? Gender ?? .none
            }            
        }
    }

	// MARK - Life cycle
	
	init() {
        self.name = String()
        self.surName = nil
        self.birthDate = nil
		self.gender = .none
    }
}

extension User {
func save() -> Bool {
	do{
		let dataString = String(decoding: try JSONEncoder().encode(self), as: UTF8.self)
		UserDefaults.standard.setValue(dataString, forKey:"User")
	}catch{
		print(error)
		return false
	}
	return true
}

enum loadError: Error {
    case noData
    case decodeError
}

static func load() throws -> User {
    var user: User
    
    let dataString = UserDefaults.standard.string(forKey: "User")
    if dataString == nil {
        throw loadError.noData
    }
    
    do {
        user = try JSONDecoder().decode(self, from: Data(dataString!.utf8))
    } catch {
        print(error)
        throw loadError.decodeError
    }
    
    return user
}
	
    func copy() -> User? {
        let user = User()
        user.name = self.name
        user.surName = self.surName
        user.birthDate = self.birthDate
        user.gender = self.gender
        return user
    }
	static func == (left: User, right: User) -> Bool {
		if left.name == right.name &&
			left.surName == right.surName &&
			left.birthDate == right.birthDate &&
			left.gender == right.gender {
			return true
		} else {
			return false
		}
	}
	static func != (left: User, right: User) -> Bool {
		if left == right {
			return false
		} else {
			return true
		}
	}
}
