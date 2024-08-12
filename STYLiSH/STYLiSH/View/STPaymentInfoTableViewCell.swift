//
//  STPaymentInfoTableViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/26.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit
import TPDirect

let creditStr = NSLocalizedString("信用卡付款", comment: "")
let cashStr = NSLocalizedString("貨到付款", comment: "")
let holderStr = NSLocalizedString("付款方式", comment: "")
let buttonStr = NSLocalizedString("確定結帳", comment: "")

private enum PaymentMethod: String {
    
    case creditCard = "信用卡付款"
    case cash = "貨到付款"
    
    var localizedString: String {
        switch self {
        case .creditCard:
            return NSLocalizedString("信用卡付款", comment: "")
        case .cash:
            return NSLocalizedString("貨到付款", comment: "")
        }
    }
}

protocol STPaymentInfoTableViewCellDelegate: AnyObject {
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell)
    
    func didChangeUserData(
        _ cell: STPaymentInfoTableViewCell,
        payment: String,
        cardNumber: String,
        dueDate: String,
        verifyCode: String
    )
    
    func checkout(_ method: String)
    
    func controllButton(_ button: UIButton)
}

class STPaymentInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tapButton: UIButton!
    
    
    @IBOutlet weak var paymentTextField: UITextField! {
        didSet {
            
            let shipPicker = UIPickerView()
            
            shipPicker.dataSource = self
            
            shipPicker.delegate = self
            
            paymentTextField.inputView = shipPicker
            
            let button = UIButton(type: .custom)
            
            button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            
            button.setBackgroundImage(
                UIImage.asset(.Icons_24px_DropDown),
                for: .normal
            )

            button.isUserInteractionEnabled = false
            
            paymentTextField.rightView = button
            
            paymentTextField.rightViewMode = .always
            
            paymentTextField.delegate = self
            
            paymentTextField.placeholder = holderStr

            paymentTextField.text = cashStr
        }
    }
    
    @IBOutlet weak var cardNumberTextField: UITextField! {
        
        didSet {
            
            cardNumberTextField.delegate = self
            cardNumberTextField.isHidden = true
        }
    }
    
    @IBOutlet weak var dueDateTextField: UITextField! {
        
        didSet {
            
            dueDateTextField.delegate = self
            dueDateTextField.isHidden = true
            
        }
    }
    
    @IBOutlet weak var verifyCodeTextField: UITextField! {
        
        didSet {
            
            verifyCodeTextField.delegate = self
            verifyCodeTextField.isHidden = true
            
        }
    }
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var shipPriceLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var productAmountLabel: UILabel!
    
    @IBOutlet weak var topDistanceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var creditView: UIView! {
        
        didSet {
            
            creditView.isHidden = true
        }
        
    }
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var totalShipPrice: UILabel!
    
    
    private let paymentMethod: [PaymentMethod] = [.cash, .creditCard]
    
    weak var delegate: STPaymentInfoTableViewCellDelegate?
    
    var tpdForm: TPDForm?
    var tpdCard: TPDCard?
    var buttonStatus: Bool = false
    var sectionStatus : String = ""
    var order: Order?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tapButton.setTitle(buttonStr, for: .normal)

        delegate?.checkout(cashStr)
        tapPay()
    }
    
    func layoutCellWith(
        productPrice: Int,
        shipPrice: Int,
        productCount: Int
    ) {
        
        productPriceLabel.text = "NT$ \(productPrice)"
        
        shipPriceLabel.text = "NT$ \(shipPrice)"
        
        totalPriceLabel.text = "NT$ \(shipPrice + productPrice)"
        
    }
    
    //MARK: -- 按下按鈕
    @IBAction func checkout(sender: UIButton) {
        if sectionStatus == "cash" {
        } else {
        }
    }
}

extension STPaymentInfoTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int
    {
        return paymentMethod.count
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return paymentMethod[row].localizedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedMethod = paymentMethod[row]
        paymentTextField.text = selectedMethod.localizedString
        
        switch selectedMethod {
        case .creditCard:
            sectionStatus = "creditCard"
            manipulateHeight(228)
            creditView.isHidden = false
            delegate?.checkout(selectedMethod.localizedString)
        case .cash:
            sectionStatus = "cash"
            manipulateHeight(44)
            creditView.isHidden = true
            delegate?.checkout(selectedMethod.localizedString)
        }
        
        delegate?.controllButton(tapButton)
    }
    
    private func manipulateHeight(_ distance: CGFloat) {
        topDistanceConstraint.constant = distance
        delegate?.didChangePaymentMethod(self)
    }
}

extension STPaymentInfoTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField != paymentTextField {
            passData()
            return
        }
        
        guard let text = textField.text,
              let payment = paymentMethod.first(where: { $0.localizedString == text }) else {
            passData()
            return
        }
        
        switch payment {
        case .cash:
            sectionStatus = "cash"
            manipulateHeight(44)
            creditView.isHidden = true
            delegate?.checkout(payment.localizedString)
        case .creditCard:
            sectionStatus = "creditCard"
            manipulateHeight(228)
            creditView.isHidden = false
            delegate?.checkout(payment.localizedString)
        }
        
        delegate?.controllButton(tapButton)
        passData()
    }
    
    private func passData() {
        
        guard let cardNumber = cardNumberTextField.text,
              let dueDate = dueDateTextField.text,
              let verifyCode = verifyCodeTextField.text,
              let paymentMethodText = paymentTextField.text else {
            return
        }
        
        delegate?.didChangeUserData(
            self,
            payment: paymentMethodText,
            cardNumber: cardNumber,
            dueDate: dueDate,
            verifyCode: verifyCode
        )
    }
}

extension STPaymentInfoTableViewCell {
    
    func tapPay() {
        tpdForm = TPDForm.setup(withContainer: creditView)
        tpdForm!.setErrorColor(UIColor.red)
        tpdForm!.setOkColor(UIColor.green)
        tpdForm!.setNormalColor(UIColor.black)
        tpdForm!.setIsUsedCcv(true)
        tpdCard = TPDCard.setup(tpdForm!)
        
        tpdForm!.onFormUpdated { [weak self] (status) in
            self?.tapButton.isEnabled = status.isCanGetPrime()
            
        }
        
        tapButton.isEnabled = false
        tapButton.alpha = 0.25
    }
    
    func submitOrder(_ order: Order) {
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
