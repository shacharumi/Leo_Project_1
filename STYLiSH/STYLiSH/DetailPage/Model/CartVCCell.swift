import UIKit

protocol CartVCCellDelegate: AnyObject {
    func reloadCell(at indexPath: IndexPath)
    func UpdateStatus(_ status: Bool)
    func cartData (_ color: String, _ size: String, _ count: Int, _ sizeSum: Int, _ ColorName: String)
}

class CartVCCell: UITableViewCell  {
    
    let productName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(hex: "#3F3A3A")
        label.numberOfLines = 0
        return label
    }()
    
    let downLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hex: "#3F3A3A")
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    let divideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#CCCCCC")
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#646464")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    let case2TitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#646464")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    let case3TitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#646464")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
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
        return button
    }()
    
    let plus: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Icons_24px_Add01"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let numberView: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.textColor = UIColor.black
        textField.text = ""
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.alpha = 0.5
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let stockNumber: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#646464")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let backImage: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Icons_24px_Close"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(productName)
        contentView.addSubview(downLabel)
        contentView.addSubview(divideView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lose)
        contentView.addSubview(plus)
        contentView.addSubview(numberView)
        contentView.addSubview(stockNumber)
        contentView.addSubview(backImage)
        contentView.addSubview(case2TitleLabel)
        contentView.addSubview(case3TitleLabel)
        
        
        backImage.addTarget(self, action: #selector(handleBackImageTapped), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange(notification:)), name: UITextField.textDidChangeNotification, object: numberView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            productName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            downLabel.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 12),
            downLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            downLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            downLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            divideView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            divideView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            divideView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1),
            divideView.heightAnchor.constraint(equalToConstant: 1),
            
            backImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            backImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backImage.heightAnchor.constraint(equalToConstant: 24),
            backImage.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    var passData: Datum?
    var sizeViews: [UIButton] = []
    
    func configure(for indexPath: IndexPath, data: Datum) {
        productName.isHidden = true
        downLabel.isHidden = true
        divideView.isHidden = true
        titleLabel.isHidden = true
        lose.isHidden = true
        numberView.isHidden = true
        plus.isHidden = true
        backImage.isHidden = true
        case2TitleLabel.isHidden = true
        case3TitleLabel.isHidden = true
        stockNumber.isHidden = true
        passData = data
        
        switch indexPath.row {
        case 0:
            productName.isHidden = false
            downLabel.isHidden = false
            divideView.isHidden = false
            backImage.isHidden = false
            productName.text = data.title
            downLabel.text = "NT $ \(data.price)"
            
        case 1:
            let noRecordStr = NSLocalizedString("選擇顏色", comment: "")
            titleLabel.text = noRecordStr
            titleLabel.isHidden = false
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ])
            // MARK: -colorview
            var colorDistance = 16
            for i in 0..<data.colors.count {
                let colorView = UIButton()
                colorView.translatesAutoresizingMaskIntoConstraints = false
                colorView.backgroundColor = UIColor(hex: data.colors[i].code)
                contentView.addSubview(colorView)
                NSLayoutConstraint.activate([
                    colorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
                    colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(colorDistance)),
                    colorView.heightAnchor.constraint(equalToConstant: 48),
                    colorView.widthAnchor.constraint(equalToConstant: 48),
                ])
                colorView.tag = i
                colorView.addTarget(self, action: #selector(colorTap(_:)), for: .touchUpInside)
                colorDistance += 64
                
                let noRecordStr = NSLocalizedString("選擇尺寸", comment: "")
                case2TitleLabel.text = noRecordStr
                case2TitleLabel.isHidden = false
                NSLayoutConstraint.activate([
                    case2TitleLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 30),
                    case2TitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                ])
                
            }
            // MARK: -sizeView
            var sizeDistance = 16
            for i in 0..<data.sizes.count {
                let sizeView = UIButton()
                sizeView.translatesAutoresizingMaskIntoConstraints = false
                sizeView.setTitle(String(data.sizes[i]), for: .normal)
                sizeView.setTitleColor(UIColor.gray, for: .normal)
                sizeView.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                sizeView.titleLabel?.textAlignment = .center
                sizeView.backgroundColor = UIColor(hex: "#F0F0F0")
                contentView.addSubview(sizeView)
                NSLayoutConstraint.activate([
                    sizeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(sizeDistance)),
                    sizeView.topAnchor.constraint(equalTo: case2TitleLabel.bottomAnchor, constant: 12),
                    sizeView.heightAnchor.constraint(equalToConstant: 48),
                    sizeView.widthAnchor.constraint(equalToConstant: 48),
                ])
                sizeDistance += 64
                sizeView.tag = i
                sizeViews.append(sizeView)
                sizeView.addTarget(self, action: #selector(sizeTap(_:)), for: .touchUpInside)
                
                let noRecordStr = NSLocalizedString("選擇數量", comment: "")
                case3TitleLabel.text = noRecordStr
                case3TitleLabel.isHidden = false
                NSLayoutConstraint.activate([
                    case3TitleLabel.topAnchor.constraint(equalTo: sizeView.bottomAnchor, constant: 30),
                    case3TitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                ])
            }
            // MARK: -NumberSelect,lose,plus
            lose.isHidden = false
            NSLayoutConstraint.activate([
                lose.topAnchor.constraint(equalTo: case3TitleLabel.bottomAnchor, constant: 12),
                lose.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                lose.heightAnchor.constraint(equalToConstant: 48),
                lose.widthAnchor.constraint(equalToConstant: 48),
            ])
            lose.addTarget(self, action: #selector(loseTap(_:)), for: .touchUpInside)
            
            plus.isHidden = false
            NSLayoutConstraint.activate([
                plus.topAnchor.constraint(equalTo: case3TitleLabel.bottomAnchor, constant: 12),
                plus.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                plus.heightAnchor.constraint(equalToConstant: 48),
                plus.widthAnchor.constraint(equalToConstant: 48),
            ])
            plus.addTarget(self, action: #selector(plusTap(_:)), for: .touchUpInside)
            
            numberView.isHidden = false
            NSLayoutConstraint.activate([
                numberView.topAnchor.constraint(equalTo: case3TitleLabel.bottomAnchor, constant: 12),
                numberView.leadingAnchor.constraint(equalTo: lose.trailingAnchor, constant: 0),
                numberView.trailingAnchor.constraint(equalTo: plus.leadingAnchor, constant: 0),
                numberView.heightAnchor.constraint(equalToConstant: 48),
                numberView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            ])
            lose.isUserInteractionEnabled = false
            plus.isUserInteractionEnabled = false
            numberView.isUserInteractionEnabled = false
            
            NSLayoutConstraint.activate([
                stockNumber.topAnchor.constraint(equalTo: case3TitleLabel.topAnchor),
                stockNumber.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ])
            
        default:
            break
        }
    }
    weak var cartDelegate: CartVCCellDelegate?
    @objc private func handleBackImageTapped() {
        cartDelegate?.reloadCell(at: IndexPath(row: 1, section: 0))
        //backImageTappedHandler?()
        for i in sizeViews {
            i.isUserInteractionEnabled = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    //MARK: -keyboard tap
    
    @objc func handleTextChange(notification: Notification) {
        if let textField = notification.object as? UITextField, textField == numberView {
            if let text = textField.text, let number = Int(text) {
                if number >= sizeSum {
                    textField.text = "\(sizeSum)"
                    numberViewNumber = sizeSum
                    plus.isUserInteractionEnabled = false
                    lose.isUserInteractionEnabled = true
                    plus.alpha = 0.5
                    lose.alpha = 1
                } else if number < 1 {
                    numberViewNumber = 1
                    textField.text = "\(numberViewNumber)"
                    lose.isUserInteractionEnabled = false
                    lose.alpha = 0.5
                } else {
                    numberViewNumber = number
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var currentSelectedBorder: UIView?
    var selectColor: String = ""
    var selectColorName: String = ""
    var sum = 0
    var nextTouch = false
    
    // MARK: --colorTap
    @objc func colorTap(_ sender: UIButton) {
        for i in sizeViews {
            i.setTitleColor(UIColor.gray, for: .normal)
            i.isUserInteractionEnabled = false
        }
        currentSelectedBorder?.removeFromSuperview()
        let selectborder = UIView()
        selectborder.backgroundColor = .clear
        selectborder.layer.borderWidth = 1
        selectborder.layer.borderColor = UIColor.black.cgColor
        selectborder.translatesAutoresizingMaskIntoConstraints = false
        selectborder.tag = sender.tag
        contentView.addSubview(selectborder)
        selectborder.isHidden = false
        NSLayoutConstraint.activate([
            selectborder.topAnchor.constraint(equalTo: sender.topAnchor, constant: -3),
            selectborder.leadingAnchor.constraint(equalTo: sender.leadingAnchor, constant: -3),
            selectborder.bottomAnchor.constraint(equalTo: sender.bottomAnchor, constant: 3),
            selectborder.heightAnchor.constraint(equalToConstant: 54),
            selectborder.widthAnchor.constraint(equalToConstant: 54),
        ])
        currentSelectedBorder = selectborder
        if let gotData = passData {
            selectColor = gotData.colors[sender.tag].code
            selectColorName = gotData.colors[sender.tag].name
            for i in 0..<gotData.variants.count {
                if gotData.variants[i].colorCode == selectColor {
                    if gotData.variants[i].stock != 0 {
                        sum += gotData.variants[i].stock
                        for j in 0..<sizeViews.count {
                            if sizeViews[j].titleLabel?.text ==  gotData.variants[i].size {
                                sizeViews[j].setTitleColor(.black, for: .normal)
                                sizeViews[j].isUserInteractionEnabled = true
                            }
                        }
                    }
                }
            }
        }
        nextTouch = true
        numberView.isUserInteractionEnabled = false
        numberView.text = ""
        numberViewNumber = 0
        lose.isUserInteractionEnabled = false
        plus.isUserInteractionEnabled = false
        plus.alpha = 0.5
        lose.alpha = 0.5
        numberView.alpha = 0.5
        currentSelectedSizeBorder?.removeFromSuperview()
        stockNumber.isHidden = true
    }
    
    var currentSelectedSizeBorder: UIView?
    var selectSize: String = ""
    var sizeSum = 0
    var numberViewNumber = 0
    
    // MARK: - sizeTap
    @objc func sizeTap(_ sender: UIButton) {
        sizeSum = 0
        if nextTouch == true {
            currentSelectedSizeBorder?.removeFromSuperview()
            let selectSizeBorder = UIView()
            selectSizeBorder.backgroundColor = .clear
            selectSizeBorder.layer.borderWidth = 1
            selectSizeBorder.layer.borderColor = UIColor.black.cgColor
            selectSizeBorder.translatesAutoresizingMaskIntoConstraints = false
            selectSizeBorder.tag = sender.tag
            contentView.addSubview(selectSizeBorder)
            selectSizeBorder.isHidden = false
            NSLayoutConstraint.activate([
                selectSizeBorder.topAnchor.constraint(equalTo: sender.topAnchor, constant: -3),
                selectSizeBorder.leadingAnchor.constraint(equalTo: sender.leadingAnchor, constant: -3),
                selectSizeBorder.bottomAnchor.constraint(equalTo: sender.bottomAnchor, constant: 3),
                selectSizeBorder.heightAnchor.constraint(equalToConstant: 54),
                selectSizeBorder.widthAnchor.constraint(equalToConstant: 54),
            ])
            if let gotData = passData {
                selectSize = gotData.sizes[sender.tag]
                for i in 0..<gotData.variants.count {
                    if gotData.variants[i].colorCode == selectColor {
                        if gotData.variants[i].size == selectSize {
                            sizeSum += gotData.variants[i].stock
                        }
                    }
                }
            }
            
            let noRecordStr = NSLocalizedString("庫存", comment: "")
            stockNumber.text = "\(noRecordStr): \(sizeSum)"
            stockNumber.isHidden = false
            numberView.isUserInteractionEnabled = true
            numberViewNumber = 1
            numberView.text = "\(numberViewNumber)"
            
            currentSelectedSizeBorder = selectSizeBorder
            if sizeSum > 1 {
                plus.isUserInteractionEnabled = true
                plus.alpha = 1
                numberView.alpha = 1
                plus.alpha = 1
            } else if sizeSum == 1 {
                plus.alpha = 0.5
                lose.alpha = 0.5
                numberView.alpha = 0.5
            }
        } else {
            for i in sizeViews {
                i.isUserInteractionEnabled = false
            }
        }
        cartDelegate?.cartData(selectColor, selectSize, numberViewNumber, sizeSum, selectColorName)
        if selectColor != "" && selectSize != "" && numberViewNumber > 0 {
            cartDelegate?.UpdateStatus(true)
        } else {
            cartDelegate?.UpdateStatus(false)
            
        }
    }
    
    @objc func plusTap(_ sender: UIButton) {
        if sizeSum > 1 {
            numberViewNumber += 1
            cartDelegate?.cartData(selectColor, selectSize, numberViewNumber, sizeSum, selectColorName)
            numberView.text = "\(numberViewNumber)"
            lose.isUserInteractionEnabled = true
            if numberViewNumber > 1 {
                lose.alpha = 1
            }
            if numberViewNumber == sizeSum {
                plus.isUserInteractionEnabled = false
                plus.alpha = 0.5
            }
        }
    }
    
    @objc func loseTap(_ sender: UIButton) {
        if sizeSum > 1 {
            numberViewNumber -= 1
            cartDelegate?.cartData(selectColor, selectSize, numberViewNumber, sizeSum, selectColorName)
            numberView.text = "\(numberViewNumber)"
            lose.alpha = 1
            if numberViewNumber == 1 {
                lose.isUserInteractionEnabled = false
                lose.alpha = 0.5
            }
            if numberViewNumber < sizeSum {
                plus.isUserInteractionEnabled = true
                plus.alpha = 1
            }
        }
    }
}

