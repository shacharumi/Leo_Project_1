import UIKit

class UserSession {
    static let shared = UserSession()

    private init() {}

    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
        }
    }
    var accessToken: String {
        get {
            return UserDefaults.standard.string(forKey: "getAccessToken")!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "getAccessToken")
        }
    }
    var prime: String {
        get {
            return UserDefaults.standard.string(forKey: "getPrime")!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "getPrime")
        }
    }
}
