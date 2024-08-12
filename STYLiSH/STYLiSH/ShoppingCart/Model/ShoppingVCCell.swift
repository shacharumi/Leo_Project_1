import UIKit
import Kingfisher
import CoreData
protocol ShoppingCartVCCellDelegate: AnyObject {
    func remove(_ removeCell: ShoppingVCCell)
    func countChange(_ cellUpdate: ShoppingVCCell, _ countUpdate: Int)
}

class ShoppingVCCell: UITableViewCell, UITextFieldDelegate {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(hex: "#3F3A3A")
        return label
    }()
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let removeButton: UIButton = {
        let button = UIButton()
        let noRecordStr = NSLocalizedString("移除", comment: "")
        
        button.setTitle(noRecordStr, for: .normal)
        button.setTitleColor(UIColor(hex: "#888888"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let divideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#D9D9D9")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(hex: "#3F3A3A")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(hex: "#3F3A3A")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lose: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Icons_24px_Subtract01"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let plus: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Icons_24px_Add01"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.alpha = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let numberView: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.textColor = UIColor.black
        textField.text = ""
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.alpha = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        numberView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange(notification:)), name: UITextField.textDidChangeNotification, object: numberView)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        numberView.delegate = self
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @objc func handleTextChange(notification: Notification) {
        if let textField = notification.object as? UITextField, textField == numberView {
            if let text = textField.text, let number = Int(text) {
                numberView.alpha = 1
                if number >= maxStock {
                    textField.text = "\(maxStock)"
                    numberViewNumber = maxStock
                    plus.isUserInteractionEnabled = false
                    lose.isUserInteractionEnabled = true
                    plus.alpha = 0.5
                    lose.alpha = 1
                    delegate?.countChange(self, numberViewNumber)
                    
                } else if number < 1 {
                    numberViewNumber = 1
                    textField.text = "\(numberViewNumber)"
                    lose.isUserInteractionEnabled = false
                    lose.alpha = 0.5
                    plus.isUserInteractionEnabled = true
                    plus.alpha = 1
                    delegate?.countChange(self, numberViewNumber)
                }else {
                }
                numberViewNumber = number
                plus.isUserInteractionEnabled = true
                lose.isUserInteractionEnabled = true
                plus.alpha = 1
                lose.alpha = 1
                delegate?.countChange(self, numberViewNumber)
            }
        }
        update()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var numberViewNumber = 0
    var maxStock = 0
    weak var delegate: ShoppingCartVCCellDelegate?
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(itemImageView)
        contentView.addSubview(removeButton)
        removeButton.addTarget(self, action: #selector(removeTap(_:)), for: .touchUpInside)
        
        contentView.addSubview(colorView)
        contentView.addSubview(divideView)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(lose)
        lose.addTarget(self, action: #selector(loseTap(_:)), for: .touchUpInside)
        
        contentView.addSubview(plus)
        plus.addTarget(self, action: #selector(plusTap(_:)), for: .touchUpInside)
        
        contentView.addSubview(numberView)
        
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImageView.widthAnchor.constraint(equalToConstant: 82),
            itemImageView.heightAnchor.constraint(equalToConstant: 110),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 24),
            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            colorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            colorView.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 24),
            colorView.widthAnchor.constraint(equalToConstant: 22),
            colorView.heightAnchor.constraint(equalToConstant: 22),
            
            divideView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            divideView.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 16),
            divideView.widthAnchor.constraint(equalToConstant: 1),
            divideView.heightAnchor.constraint(equalToConstant: 14),
            
            sizeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            sizeLabel.leadingAnchor.constraint(equalTo: divideView.trailingAnchor, constant: 16),
            
            priceLabel.topAnchor.constraint(equalTo: removeButton.bottomAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            lose.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            lose.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 24),
            lose.widthAnchor.constraint(equalToConstant: 32),
            lose.heightAnchor.constraint(equalToConstant: 32),
            
            plus.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            plus.leadingAnchor.constraint(equalTo: numberView.trailingAnchor),
            plus.widthAnchor.constraint(equalToConstant: 32),
            plus.heightAnchor.constraint(equalToConstant: 32),
            
            numberView.leadingAnchor.constraint(equalTo: lose.trailingAnchor, constant: 0),
            numberView.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            numberView.trailingAnchor.constraint(equalTo: plus.leadingAnchor, constant: 0),
            numberView.heightAnchor.constraint(equalToConstant: 32),
            numberView.widthAnchor.constraint(equalToConstant: 86),
            numberView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
        ])
    }
    
    func configure(for indexPath: IndexPath, data: [ShoppingCart]) {
        itemImageView.kf.setImage(with: URL(string: data[indexPath.row].productImage!))
        titleLabel.text = data[indexPath.row].productName
        if let colorNumber = data[indexPath.row].productColor {
            colorView.backgroundColor = UIColor(hex: colorNumber)
        } else {
            colorView.backgroundColor = nil
        }
        
        sizeLabel.text = data[indexPath.row].productSize
        numberViewNumber = Int(data[indexPath.row].productCount)
        priceLabel.text = "NT$\(data[indexPath.row].totalPrice)"
        
        
        maxStock = Int(data[indexPath.row].sizeSum)
        
        if numberViewNumber > 1 {
            lose.isUserInteractionEnabled = true
            lose.alpha = 1
        }
        if numberViewNumber == maxStock {
            plus.isUserInteractionEnabled = false
            plus.alpha = 0.5
        }
        if numberViewNumber == 1 {
            lose.isUserInteractionEnabled = false
            lose.alpha = 0.5
        }
        numberView.text = "\(data[indexPath.row].productCount)"
    }
    
    @objc func loseTap(_ sender: UIButton) {
        plus.isUserInteractionEnabled = true
        if numberViewNumber > 1 {
            lose.isUserInteractionEnabled = true
            numberViewNumber -= 1
            
            numberView.text = "\(numberViewNumber)"
            delegate?.countChange(self, numberViewNumber)
            lose.alpha = 1
            plus.alpha = 1
        }
        if numberViewNumber == 1{
            delegate?.countChange(self, numberViewNumber)
            lose.isUserInteractionEnabled = false
            lose.alpha = 0.5
        }
    }
    
    @objc func plusTap(_ sender: UIButton) {
        if numberViewNumber < maxStock {
            numberViewNumber += 1
            
            numberView.text = "\(numberViewNumber)"
            delegate?.countChange(self, numberViewNumber)
            
            lose.isUserInteractionEnabled = true
            lose.alpha = 1
            plus.alpha = 1
            if numberViewNumber == maxStock {
                plus.isUserInteractionEnabled = false
                plus.alpha = 0.5
            }
        } else if numberViewNumber >= maxStock{
            delegate?.countChange(self, numberViewNumber)
            plus.isUserInteractionEnabled = false
            plus.alpha = 0.5
        }
        
    }
    
    @objc func removeTap(_ sender: UIButton) {
        delegate?.remove(self)
    }
}

extension ShoppingVCCell {
    func update() {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShoppingCart> = ShoppingCart.fetchRequest()
        do {
            if let cartItems = try context?.fetch(fetchRequest) {
                for item in cartItems {
//                    print("Product: \(item.productName ?? ""), Color: \(item.productColor ?? ""), Size: \(item.productSize ?? ""), Count: \(item.productCount), Price: \(item.productPrice), totalPrice: \(item.totalPrice)")
                }
            }
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }
}
