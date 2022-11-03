import Foundation
import Moya

enum UserService {
    case logIn(name: String, password: String)
    case editUserName(newName: String, userID: Int)
    case userDetail(userID: Int)
    case onlineUser
    case offlineUser
}

extension UserService: TargetType {
    var baseURL: URL {
        return URL(string: "http://192.168.101.27:8091")!
    }
    
    var path: String {
        switch self {
        case .logIn:
            return "/user/login"
        case .editUserName(_, let userID):
            return "/admin/edit/\(userID)"
        case .userDetail(let userID):
            return "/admin/\(userID)"
        case .onlineUser:
            return "/attendance/duty"
        case .offlineUser:
            return "/attendance/not/duty"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .logIn:
            return .post
        case .userDetail, .onlineUser, .offlineUser:
            return .get
        case .editUserName:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .logIn(let name, let password):
            return .requestParameters(
                parameters:
                    [
                        "name" : name,
                        "password" : password
                    ],
                encoding: JSONEncoding.default
            )
        case .editUserName(let newName, _):
            return .requestParameters(
                parameters:
                    [
                        "name" : newName
                    ],
                encoding: JSONEncoding.default
            )
        
        case .userDetail, .onlineUser, .offlineUser:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .logIn, .onlineUser, .offlineUser:
            return Header.tokenIsEmpty.header()
        case .userDetail, .editUserName:
            return Header.accessToken.header()
        }
    }
}
