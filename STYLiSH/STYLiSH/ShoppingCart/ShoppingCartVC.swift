import UIKit
import CoreData
import IQKeyboardManagerSwift
import Kingfisher

class ShoppingCartVC: UIViewController, ShoppingCartVCCellDelegate {
    var shoppingCartTableView: UITableView!
    var cartItems: [ShoppingCart] = []
    let viewInit = TouchButton()
    let buttonView = UIView()
    let button = TouchButton().button()

    @IBOutlet weak var navitgationBar: UINavigationItem!
    
    @IBAction func signOutButton(_ sender: UIBarButtonItem) {
        UserSession.shared.isLoggedIn = false
        UserSession.shared.accessToken = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        let noRecordStr = NSLocalizedString("購物車", comment: "")
        let noRecordStrLogOut = NSLocalizedString("登出", comment: "")

        navitgationBar.title = noRecordStr
        navitgationBar.rightBarButtonItem?.title = noRecordStrLogOut
        shoppingCartTableView = UITableView()
        shoppingCartTableView.delegate = self
        shoppingCartTableView.dataSource = self
        shoppingCartTableView.register(ShoppingVCCell.self, forCellReuseIdentifier: "shoppingCartCell")
        shoppingCartTableView.estimatedRowHeight = 200
        shoppingCartTableView.rowHeight = UITableView.automaticDimension
        shoppingCartTableView.translatesAutoresizingMaskIntoConstraints = false
        shoppingCartTableView.isUserInteractionEnabled = true
        shoppingCartTableView.separatorStyle = .none
        view.addSubview(shoppingCartTableView)
        let topBorderView = viewInit.topBorder()
        view.addSubview(topBorderView)
        setUpButtonView()
        
        cartItems = fetchCoreData()
       
        NotificationCenter.default.addObserver(self, selector: #selector(reLoadPage), name: .shoppingCartUpdated, object: nil)
        
        
        NSLayoutConstraint.activate([
            shoppingCartTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoppingCartTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoppingCartTableView.bottomAnchor.constraint(equalTo: buttonView.topAnchor),
            shoppingCartTableView.topAnchor.constraint(equalTo: view.topAnchor),
            
            topBorderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBorderView.heightAnchor.constraint(equalToConstant: 1),
            topBorderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topBorderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func countChange(_ cellUpdate: ShoppingVCCell, _ countUpdate: Int) {
        if let indexPath = shoppingCartTableView.indexPath(for: cellUpdate) {
            let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            cartItems[indexPath.row].productCount = Int16(countUpdate)
            cartItems[indexPath.row].totalPrice = Int16(countUpdate)*cartItems[indexPath.row].productPrice
            
            do {
                try context?.save()
                cartItems = fetchCoreData()
                shoppingCartTableView.reloadData()
                NotificationCenter.default.post(name: .shoppingCartUpdated, object: nil)
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func remove(_ removeCell: ShoppingVCCell) {
        if let indexPath = shoppingCartTableView.indexPath(for: removeCell) {
            let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            let itemToRemove = cartItems[indexPath.row]
            context?.delete(itemToRemove)
            do {
                try context?.save()
                cartItems.remove(at: indexPath.row)
                shoppingCartTableView.deleteRows(at: [indexPath], with: .automatic)
                NotificationCenter.default.post(name: .shoppingCartUpdated, object: nil)
                
            } catch {
                print("\(error)")
            }
        }
    }
    
    func setUpButtonView() {
        buttonView.addSubview(button)
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView)
        
        let topBorder = viewInit.topBorder()
        buttonView.addSubview(topBorder)
        
        NSLayoutConstraint.activate([
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            topBorder.topAnchor.constraint(equalTo: buttonView.topAnchor),
            topBorder.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            topBorder.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            topBorder.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

extension ShoppingCartVC: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = shoppingCartTableView.dequeueReusableCell(withIdentifier: "shoppingCartCell", for: indexPath) as? ShoppingVCCell else {
            fatalError("The dequeued cell is not an instance of ShoppingVCCell.")
        }
        cell.configure(for: indexPath, data: cartItems)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
    
}

extension ShoppingCartVC {
    // MARK: -fetchCoreData
    func fetchCoreData() -> [ShoppingCart] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShoppingCart> = ShoppingCart.fetchRequest()
        do {
            let cartItems = try context.fetch(fetchRequest)
            return cartItems
        } catch {
            print("Failed to fetch items: \(error)")
            return []
        }
    }
    
    @objc func reLoadPage() {
        cartItems = fetchCoreData()
        shoppingCartTableView.reloadData()
        if cartItems == [] {
            button.isUserInteractionEnabled = false
        } else {
            button.isUserInteractionEnabled = true

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "billSegue" {
            if let billPage = segue.destination as? BillPage {
                    billPage.billItemData = cartItems
            }
        }
    }
    
    @objc func buttonTap() {
        self.performSegue(withIdentifier: "billSegue", sender: self)
        self.tabBarController?.tabBar.isHidden = false

    }
}

extension Notification.Name {
    static let shoppingCartUpdated = Notification.Name("shoppingCartUpdated")
}
