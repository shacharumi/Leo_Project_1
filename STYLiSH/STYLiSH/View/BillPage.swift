import UIKit
import Kingfisher
import TPDirect
import IQKeyboardManagerSwift

class BillPage: UIViewController {
    let creditStr = NSLocalizedString("信用卡付款", comment: "")
    let cashStr = NSLocalizedString("貨到付款", comment: "")
    let header = ["結帳商品", "收件資訊", "付款詳情"]
    var billItem: ShoppingCart?
    var billItemData: [ShoppingCart] = []
    var tpdCard: TPDCard!
    var passTpdForm: TPDForm!
    var cardNumber: String!
    var checkUserInfoStatus: Bool = false
    var caseStatus: String = "貨到付款"
    var username: String?, email: String?, phoneNumber: String?, address: String?, shipTime: String?
    var prime: String = ""
    var passCreditView: UIView!
    var passButton: UIButton!
    var order: Order? = nil
    var productPriceTotal = 0
    var productCount = 0

    @IBAction func backTap(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false

    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = NSLocalizedString("結帳", comment: "")
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.leftBarButtonItem?.isHidden = false
        
        tableView.lk_registerCellWithNib(identifier: String(describing: STOrderProductCell.self), bundle: nil)
        tableView.lk_registerCellWithNib(identifier: String(describing: STOrderUserInputCell.self), bundle: nil)
        tableView.lk_registerCellWithNib(identifier: String(describing: STPaymentInfoTableViewCell.self), bundle: nil)
        
        tableView.separatorStyle = .none
        
        let headerXib = UINib(nibName: String(describing: STOrderHeaderView.self), bundle: nil)
        tableView.register(headerXib, forHeaderFooterViewReuseIdentifier: String(describing: STOrderHeaderView.self))
    }
}

extension BillPage: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: STOrderHeaderView.self)) as? STOrderHeaderView else {
            return nil
        }
        switch section {
        case 0:
            let noRecordStr = NSLocalizedString("結帳商品", comment: "")
            headerView.titleLabel.text = noRecordStr
        case 1:
            let noRecordStr = NSLocalizedString("收件資訊", comment: "")
            headerView.titleLabel.text = noRecordStr
        case 2:
            let noRecordStr = NSLocalizedString("付款詳情", comment: "")
            headerView.titleLabel.text = noRecordStr
        default:
            print("error")
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footerView = view as? UITableViewHeaderFooterView else { return }
        footerView.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: "cccccc")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return header.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? billItemData.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return configureProductCell(for: indexPath)
        case 1:
            return configureUserInputCell(for: indexPath)
        default:
            return configurePaymentInfoCell(for: indexPath)
        }
    }
    
    private func configureProductCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STOrderProductCell.self), for: indexPath) as! STOrderProductCell
        let item = billItemData[indexPath.row]
        
        cell.productImageView.kf.setImage(with: URL(string: item.productImage!))
        cell.productTitleLabel.text = item.productName
        cell.colorView.backgroundColor = UIColor(hex: item.productColor!)
        cell.productSizeLabel.text = item.productSize
        cell.priceLabel.text = "\(item.productPrice)"
        cell.orderNumberLabel.text = "\(item.productCount)"
        productPriceTotal += Int(item.productPrice*item.productCount)
        cell.priceLabel.text = "\(item.productPrice*item.productCount)"
        productCount += 1
        return cell
    }
    
    private func configureUserInputCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STOrderUserInputCell.self), for: indexPath) as! STOrderUserInputCell
        cell.delegate = self
        
        return cell
    }
    
    private func configurePaymentInfoCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STPaymentInfoTableViewCell.self), for: indexPath) as! STPaymentInfoTableViewCell
        cell.delegate = self
        passCreditView = cell.creditView
        passButton = cell.tapButton
        passTpdForm = cell.tpdForm
        cell.totalPrice.text = NSLocalizedString("商品總金額", comment: "")
        cell.totalShipPrice.text = NSLocalizedString("運費總金額", comment: "")
        cell.productAmountLabel.text = ""
        cell.productPriceLabel.text = "\(productPriceTotal)"
        cell.shipPriceLabel.text = "60"
        cell.totalPriceLabel.text = "\(productPriceTotal+60)"
        let amountStrFormat = NSLocalizedString("總計 (%d樣商品)", comment: "")
        cell.productAmountLabel.text = String.localizedStringWithFormat(amountStrFormat, productCount)
        passButton.addTarget(self, action: #selector(getPrimeAndSubmitOrder), for: .touchUpInside)
        return cell
    }
}

extension BillPage: STPaymentInfoTableViewCellDelegate {
    
    
    func getPrime(_ prime: String) {
        self.prime = prime
    }
    
    
    func controllButton(_ button: UIButton) {
        if (caseStatus == cashStr || caseStatus == creditStr) && checkUserInfoStatus {
            button.isUserInteractionEnabled = true
            button.alpha = 1
            if caseStatus == creditStr {
                button.backgroundColor = .lightGray
            }
        }
    }
    
    func checkout(_ method: String) {
        self.caseStatus = method
    }
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell) {
        tableView.reloadData()
    }
    
    func didChangeUserData(_ cell: STPaymentInfoTableViewCell, payment: String, cardNumber: String, dueDate: String, verifyCode: String) {
        self.cardNumber = cardNumber
      
    }
}

extension BillPage: STOrderUserInputCellDelegate {
    func personStatus(_ status: Bool) {
        checkUserInfoStatus = status
    }
    
    func didChangeUserData(_ cell: STOrderUserInputCell, username: String, email: String, phoneNumber: String, address: String, shipTime: String) {
        self.username = username
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.shipTime = shipTime
    
    }
}

extension BillPage {
    func orderSetting() -> Order {
        let products: [List] = billItemData.map { item in
            List(
                id: String(item.productId),
                name: item.productName!,
                price: Int(item.productPrice),
                color: Color(code: item.productColor!, name: item.colorName!),
                size: item.productSize!,
                qty: Int(item.productCount)
            )

        }
        
        return Order(
            shipping: "delivery",
            payment: "credit_card",
            subtotal: self.productPriceTotal,
            freight: 60,
            total: self.productPriceTotal+60,
            recipient: Recipient(
                name: self.username!,
                phone: self.phoneNumber!,
                email: self.email!,
                address: self.address!,
                time: self.shipTime!
            ),
            list: products
        )
    }
}

extension BillPage {
    @objc func getPrimeAndSubmitOrder() {
        guard let tpdForm = passTpdForm else {
            print("tpdForm is nil")
            return
        }
        tpdCard = TPDCard.setup(tpdForm)
        tpdCard?.onSuccessCallback { [weak self] (prime, cardInfo, cardIdentifier, merchantReferenceInfo) in
            DispatchQueue.main.async {
                UserSession.shared.prime = prime!
                self?.submitOrder(self?.orderSetting())
                self?.performSegue(withIdentifier: "checkoutSegue", sender: self)

            }
        }.onFailureCallback { (status, message) in
            let result = "Status: \(status), Message: \(message)"
        }.getPrime()
    }
    
    func submitOrder(_ order: Order?) {
        guard let order = order else {
            print("Order is nil")
            return
        }
        
        let postData = CheckoutData(prime: UserSession.shared.prime, order: order)
        
        guard let jsonData = try? JSONEncoder().encode(postData) else {
            print("Failed to encode JSON data")
            return
        }
        
        guard let url = URL(string: "https://api.appworks-school.tw/api/1.0/order/checkout") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserSession.shared.accessToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error")
                return
            }
            
            if let data = data,
               let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("Response JSON: \(jsonResponse)")
            }
        }
        
        task.resume()
    }
}
