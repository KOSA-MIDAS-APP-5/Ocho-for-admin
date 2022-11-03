import Foundation

struct Token {
    static var _accessToken: String?
    static var accessToken: String? {
        get {
            _accessToken =  UserDefaults.standard.string(forKey: "acccess_token")
            return _accessToken
        }
        
        set(newToken) {
            UserDefaults.standard.set(newToken, forKey: "acccess_token")
            _accessToken = newToken
        }
    }
    
    static func removeToken() {
        self.accessToken = nil
    }
}

enum Header {
    case accessToken, tokenIsEmpty
    
    func header() -> [String : String]? {
        guard let token = Token.accessToken else {
            return ["Content-Type" : "application/json"]
        }
        
        switch self {
        case .accessToken:
            return ["ACCESS_TOKEN" : token, "Content-Type" : "application/json"]
        case .tokenIsEmpty:
            return ["Content-Type" : "application/json"]
        }
    }
}
