import UIKit
import FacebookLogin

class FBPopupView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        let titleLabel = UILabel()
        titleLabel.text = "請先登入會員"
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        let contentLabel = UILabel()
        contentLabel.text = "登入會員後即可完成結帳。"
        contentLabel.textColor = .black
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentLabel)
        
        let divideView = UIView()
        divideView.backgroundColor = UIColor(hex: "#CCCCCC")
        divideView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(divideView)
        
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Facebook 登入", for: .normal)
        loginButton.backgroundColor = UIColor(hex: "#3B5998")
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loginButton)
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "Icons_24px_Close"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)

        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            contentLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 73),
            contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            divideView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 20),
            divideView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            divideView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            divideView.heightAnchor.constraint(equalToConstant: 1),
            
            loginButton.topAnchor.constraint(equalTo: divideView.bottomAnchor, constant: 17),
            loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
        ])
    }
    
    @objc func loginButtonTapped() {
        let manager = LoginManager()
        let configuration = LoginConfiguration(permissions: [.publicProfile, .email])
        
        manager.logIn(configuration: configuration) { result in
            switch result {
            case .success(_, _, let token):
                guard let accessToken = token?.tokenString else { return }
                let url = URL(string: "https://api.appworks-school.tw/api/1.0/user/signin")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let requestBody: [String: Any] = [
                    "provider": "facebook",
                    "access_token": accessToken
                ]
                
                request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "Unknown error")
                        return
                    }
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        do {
                            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let accessToken = jsonData["data"] as? [String: Any],
                               let token = accessToken["access_token"] as? String {
                                UserSession.shared.accessToken = token
                                UserSession.shared.isLoggedIn = true
                                DispatchQueue.main.async {
                                    self.closeView()                           
                                }
                            } else {
                                print("Failed to parse JSON or access token is missing")
                            }
                        } catch {
                            print("JSONSerialization error: \(error.localizedDescription)")
                        }
                    } else {
                        print("Failed to sign in. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                    }
                }
                task.resume()
                
            case .cancelled:
                print("User cancelled login.")
            case .failed(let error):
                print("Login failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func closeView() {
        self.removeFromSuperview()
        self.layoutIfNeeded()

    }
}
