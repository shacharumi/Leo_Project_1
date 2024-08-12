import UIKit
import CoreData

extension Notification.Name {
    static let loginSuccess = Notification.Name("loginSuccess")
}

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var viewHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadge), name: .shoppingCartUpdated, object: nil)
        
        if let viewControllers = self.viewControllers {
            let firstVC = viewControllers[0]
            let secondVC = viewControllers[1]
            let thirdVC = viewControllers[2]
            let fourthVC = viewControllers[3]
            
            firstVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Icons_36px_Home_Normal"), selectedImage: UIImage(named: "Icons_36px_Home_Selected"))
            secondVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Icons_36px_Catalog_Normal"), selectedImage: UIImage(named: "Icons_36px_Catalog_Selected"))
            thirdVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Icons_36px_Cart_Normal"), selectedImage: UIImage(named: "Icons_36px_Cart_Selected"))
            fourthVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Icons_36px_Profile_Normal"), selectedImage: UIImage(named: "Icons_36px_Profile_Selected"))
            
            thirdVC.tabBarItem.badgeColor = UIColor(hex: "#845932")
        }
        
        updateBadge()
    }
    
    @objc func updateBadge() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<ShoppingCart> = ShoppingCart.fetchRequest()
        let cartItems = try? context.fetch(fetchRequest)
        let itemCount = cartItems?.count ?? 0
        
        if let viewControllers = self.viewControllers {
            let thirdVC = viewControllers[2]
            thirdVC.tabBarItem.badgeValue = itemCount > 0 ? "\(itemCount)" : nil
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .shoppingCartUpdated, object: nil)
        NotificationCenter.default.removeObserver(self, name: .loginSuccess, object: nil)
    }
    
    func deleteAllData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entities = context.persistentStoreCoordinator?.managedObjectModel.entities
        entities?.forEach({ entityDescription in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityDescription.name!)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print("There was an error deleting entity \(entityDescription.name!): \(error)")
            }
        })
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) {
            if selectedIndex == 2 || selectedIndex == 3 {
                if !UserSession.shared.isLoggedIn {
                    showPopupView()
                    return false
                }
            }
        }
        return true
    }
    
    private func showPopupView() {
        let popupView = FBPopupView()
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        let grayView = UIView()
        grayView.backgroundColor = .gray
        grayView.alpha = 0.5
        grayView.translatesAutoresizingMaskIntoConstraints = false
        grayView.tag = 102

        view.addSubview(grayView)
        view.addSubview(popupView)

        NSLayoutConstraint.activate([
            grayView.topAnchor.constraint(equalTo: view.topAnchor),
            grayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayView.bottomAnchor.constraint(equalTo: popupView.topAnchor),
            
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
        
        viewHeightConstraint = popupView.heightAnchor.constraint(equalToConstant: 0)
        viewHeightConstraint?.isActive = true
        
        self.viewHeightConstraint?.constant = 199
        self.view.layoutIfNeeded()
    }
}
