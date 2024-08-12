//
//  STUserInputCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/25.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

protocol STOrderUserInputCellDelegate: AnyObject {
    
    func didChangeUserData(
        _ cell: STOrderUserInputCell,
        username: String,
        email: String,
        phoneNumber: String,
        address: String,
        shipTime: String
    )
    func personStatus (_ status: Bool)
}

class STOrderUserInputCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var shipTimeSelector: UISegmentedControl!
    
    @IBOutlet weak var shipTime: UILabel!
    
    weak var delegate: STOrderUserInputCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        emailTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        phoneTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        addressTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        shipTimeSelector.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .valueChanged)
        phoneTextField.keyboardType = .numberPad
        phoneTextField.delegate = self
        let nameStr = NSLocalizedString("收件人姓名", comment: "")
        nameTextField.placeholder = nameStr
        let phoneStr = NSLocalizedString("手機號碼", comment: "")
        phoneTextField.placeholder = phoneStr
        let addressStr = NSLocalizedString("地址", comment: "")
        addressTextField.placeholder = addressStr
        let shipStr = NSLocalizedString("不指定", comment: "")
        shipTimeSelector.setTitle(shipStr, forSegmentAt: 2)
        shipTime.text =  NSLocalizedString("配送時間", comment: "")
    }
}

extension STOrderUserInputCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard
            let name = nameTextField.text,
            let email = emailTextField.text,
            let phoneNumber = phoneTextField.text,
            let address = addressTextField.text,
            let shipTime = shipTimeSelector.titleForSegment(at: shipTimeSelector.selectedSegmentIndex) else
        {
            return
        }
        
        delegate?.didChangeUserData(
            self,
            username: name,
            email: email,
            phoneNumber: phoneNumber,
            address: address,
            shipTime: shipTime
        )
        
        if nameTextField.text != "" && emailTextField.text != "" && phoneTextField.text != "" && addressTextField.text != "" {
            delegate?.personStatus(true)
        } else {
            delegate?.personStatus(false)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let allowedCharacterSet = CharacterSet.decimalDigits
            let replacementStringIsValid = string.rangeOfCharacter(from: allowedCharacterSet) != nil || string.isEmpty
            return replacementStringIsValid
        }
}

class STOrderUserInputTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addUnderLine()
    }
    
    private func addUnderLine() {
        
        let underline = UIView()
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(underline)
        
        NSLayoutConstraint.activate([
            
            leadingAnchor.constraint(equalTo: underline.leadingAnchor),
            trailingAnchor.constraint(equalTo: underline.trailingAnchor),
            bottomAnchor.constraint(equalTo: underline.bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        
        underline.backgroundColor = UIColor.hexStringToUIColor(hex: "cccccc")
    }
}
