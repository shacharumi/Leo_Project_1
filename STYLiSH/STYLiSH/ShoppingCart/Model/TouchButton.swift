import UIKit

class TouchButton {
    
    func backButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Icons_44px_Back01"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func button() -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#3F3A3A")
        let noRecordStr = NSLocalizedString("加入購物車", comment: "")
        button.setTitle(noRecordStr, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    func topBorder() -> UIView{
        let topBorder = UIView()
        topBorder.backgroundColor = UIColor.lightGray
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        return topBorder
    }
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFFE5")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
