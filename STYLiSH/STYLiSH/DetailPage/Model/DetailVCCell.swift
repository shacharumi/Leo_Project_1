import UIKit

class DetailVCCell: UITableViewCell {
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(hex: "#646464")
        label.numberOfLines = 0
        return label
    }()
    
    let productIDLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hex: "#646464")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(hex: "#646464")
        label.numberOfLines = 0
        return label
    }()
    
    let storyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(hex: "#646464")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let otherPropertyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(hex: "#646464")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let otherPropertyDataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(hex: "#3F3A3A")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let divideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#D9D9D9")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productIDLabel)
        contentView.addSubview(productPriceLabel)
        contentView.addSubview(storyLabel)
        contentView.addSubview(otherPropertyLabel)
        contentView.addSubview(otherPropertyDataLabel)
        contentView.addSubview(divideView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            productPriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            productPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            productIDLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productIDLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productIDLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),
            productIDLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            storyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            storyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            storyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            storyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            otherPropertyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            otherPropertyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            otherPropertyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            divideView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            divideView.leadingAnchor.constraint(equalTo: otherPropertyLabel.trailingAnchor, constant: 8),
            divideView.heightAnchor.constraint(equalToConstant: 13),
            divideView.widthAnchor.constraint(equalToConstant: 1),
            
            otherPropertyDataLabel.leadingAnchor.constraint(equalTo: divideView.trailingAnchor, constant: 16),
            otherPropertyDataLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            otherPropertyDataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
}
    
    func configure(for indexPath: IndexPath, data: Datum) {
        productNameLabel.isHidden = true
        productIDLabel.isHidden = true
        productPriceLabel.isHidden = true
        storyLabel.isHidden = true
        otherPropertyLabel.isHidden = true
        otherPropertyDataLabel.isHidden = true
        divideView.isHidden = true
        
        switch indexPath.row {
        case 0:
            productNameLabel.isHidden = false
            productIDLabel.isHidden = false
            productPriceLabel.isHidden = false
            productNameLabel.text = data.title
            productIDLabel.text = "\(data.id)"
            productPriceLabel.text = "NT $ \(data.price)"
            
        case 1:
            storyLabel.isHidden = false
            storyLabel.text = data.story
            
        case 2:
            let noRecordStr = NSLocalizedString("顏色", comment: "")
            otherPropertyLabel.text = noRecordStr
            otherPropertyLabel.isHidden = false
            divideView.isHidden = false
            var distance = 16
            for i in 0..<data.colors.count{
                let colorView = UIView()
                colorView.translatesAutoresizingMaskIntoConstraints = false
                colorView.backgroundColor = UIColor(hex: data.colors[i].code)
                colorView.layer.borderColor = UIColor.black.cgColor 
                colorView.layer.borderWidth = 1.0
                contentView.addSubview(colorView)

                NSLayoutConstraint.activate([
                    colorView.leadingAnchor.constraint(equalTo: divideView.trailingAnchor, constant: CGFloat(distance)),
                    colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                    colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                    colorView.heightAnchor.constraint(equalToConstant: 24),
                    colorView.widthAnchor.constraint(equalToConstant: 24),
                ])
                distance += 34
            }

        case 3:
            let noRecordStr = NSLocalizedString("尺寸", comment: "")
            otherPropertyLabel.text = noRecordStr
            otherPropertyLabel.isHidden = false
            divideView.isHidden = false
            otherPropertyDataLabel.isHidden = false
            let index = data.sizes.count
            otherPropertyDataLabel.text = "\(data.sizes[0]) -  \(data.variants[index-1].size)"
            
        case 4:
            let noRecordStr = NSLocalizedString("庫存", comment: "")
            otherPropertyLabel.text = noRecordStr
            otherPropertyLabel.isHidden = false
            divideView.isHidden = false
            otherPropertyDataLabel.isHidden = false
            var sum = 0
            for data in data.variants {
                sum += data.stock
            }
            otherPropertyDataLabel.text = "\(sum)"
            
        case 5:
            let noRecordStr = NSLocalizedString("材質", comment: "")
            otherPropertyLabel.text = noRecordStr
            otherPropertyLabel.isHidden = false
            divideView.isHidden = false
            otherPropertyDataLabel.isHidden = false
            otherPropertyDataLabel.text = "\(data.texture)"

        case 6:
            let noRecordStr = NSLocalizedString("洗滌", comment: "")
            otherPropertyLabel.text = noRecordStr
            otherPropertyLabel.isHidden = false
            divideView.isHidden = false
            otherPropertyDataLabel.isHidden = false
            otherPropertyDataLabel.text = "\(data.wash)"

        case 7:
            let noRecordStr = NSLocalizedString("產地", comment: "")
            otherPropertyLabel.text = noRecordStr
            otherPropertyLabel.isHidden = false
            divideView.isHidden = false
            otherPropertyDataLabel.isHidden = false
            otherPropertyDataLabel.text = "\(data.place)"

        case 8:
            let noRecordStr = NSLocalizedString("備註", comment: "")
            otherPropertyLabel.text = noRecordStr
            otherPropertyLabel.isHidden = false
            divideView.isHidden = false
            otherPropertyDataLabel.isHidden = false
            otherPropertyDataLabel.text = "\(data.note)"

        default:
            break
        }
    }
}


