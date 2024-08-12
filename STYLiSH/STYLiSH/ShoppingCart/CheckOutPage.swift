import UIKit
import CoreData

class CheckOutPage: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        clearCoreData()
        removeBadgeFromTabBar()
        self.navigationItem.title = NSLocalizedString("結帳結果", comment: "")
    }
}

extension CheckOutPage {
    func setUI() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Icons_60px_Success03")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("結帳成功", comment: "")
        titleLabel.textColor = UIColor(hex: "#000000")
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let textLabel = UILabel()
        let textLabelStr = NSLocalizedString("我們收到您的訂單了！將以最快的速度為您安排出貨。", comment: "")

        textLabel.text = textLabelStr
        textLabel.numberOfLines = 2
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.textColor = UIColor(hex: "#3F3A3A")
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)

        let button = UIButton()
        let buttonStr = NSLocalizedString("再去逛逛", comment: "")

        button.setTitle(buttonStr, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#3F3A3A")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(presentNextViewController), for: .touchUpInside)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    @objc func presentNextViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "shoppingCart") as? ShoppingCartVC {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    func clearCoreData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ShoppingCart")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            print("刪除數據失敗：\(error), \(error.userInfo)")
        }
    }
    
    func removeBadgeFromTabBar() {
            if let tabBarController = self.tabBarController {
                let tabBarItems = tabBarController.tabBar.items
                    tabBarItems![2].badgeValue = nil
            }
        }
}
