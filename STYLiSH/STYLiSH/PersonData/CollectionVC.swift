import UIKit
import FacebookLogin
import Kingfisher

class CollectionVC : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var fbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var navigationLabel: UILabel!
    @IBOutlet weak var collectionVC: UICollectionView!
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var accessToken : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionVC.dataSource = self
        collectionVC.delegate = self
        navigationLabel.font = UIFont.systemFont(ofSize: 16, weight: .black)
        let noRecordStr = NSLocalizedString("個人", comment: "")
        navigationLabel.text = noRecordStr
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: collectionVC.frame.width, height: 80)
        layout.itemSize = CGSize(width: 60.0, height: 50.0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)
        layout.minimumLineSpacing = 30.0
        collectionVC.setCollectionViewLayout(layout, animated: false)
        fetchUserProfile(token: UserSession.shared.accessToken)
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section == 0 ? 5 : 8
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? CollectionVCCell {
                if indexPath.section == 0 {
                    let noRecordStrHeader = NSLocalizedString("我的訂單", comment: "")
                    let noRecordStrExtra = NSLocalizedString("查看全部", comment: "")
                    header.headerLabel.text = noRecordStrHeader
                    header.extraLabel.text = noRecordStrExtra
                    header.headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .black)
                }else {
                    let noRecordStrHeader = NSLocalizedString("更多服務", comment: "")
                    header.headerLabel.text = noRecordStrHeader
                    header.extraLabel.text = ""
                    header.headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .black)
                }
                return header
            }
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  section == 0 ? (screenWidth-330)/4 : (screenWidth-270)/4
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionVC.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CollectionVCCell {
            cell.cellLabel.lineBreakMode = .byTruncatingTail
            if indexPath.section == 0 {
                switch indexPath.item {
                case 0:
                    let noRecordStr = NSLocalizedString("待付款", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_AwaitingPayment")
                case 1:
                    let noRecordStr = NSLocalizedString("待出貨", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_AwaitingShipment")
                case 2:
                    let noRecordStr = NSLocalizedString("待簽收", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_Shipped")
                case 3:
                    let noRecordStr = NSLocalizedString("待評價", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_AwaitingShipment")
                case 4:
                    let noRecordStr = NSLocalizedString("退換貨", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_Exchange")
                default:
                    cell.cellImage.image = UIImage(named: "defaultImage")
                    cell.cellLabel.text = "default"            }
            } else {
                switch indexPath.item {
                case 0:
                    let noRecordStr = NSLocalizedString("收藏", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_Starred")
                case 1:
                    let noRecordStr = NSLocalizedString("貨到通知", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_Notification")
                case 2:
                    let noRecordStr = NSLocalizedString("帳戶退款", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_Refunded")
                case 3:
                    let noRecordStr = NSLocalizedString("地址", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_Address")
                case 4:
                    let noRecordStr = NSLocalizedString("客服訊息", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_CustomerService")
                case 5:
                    let noRecordStr = NSLocalizedString("系統回饋", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_Refunded")
                case 6:
                    let noRecordStr = NSLocalizedString("手機綁定", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_RegisterCellphone")
                case 7:
                    let noRecordStr = NSLocalizedString("設定", comment: "")
                    cell.cellLabel.text = noRecordStr
                    cell.cellImage.image = UIImage(named: "Icons_24px_Settings")
                default:
                    cell.cellImage.image = UIImage(named: "defaultImage")
                    cell.cellLabel.text = "default"              }
            }
            return cell
        }
        return UICollectionViewCell()
    }
}


extension CollectionVC {
    private func fetchUserProfile(token: String) {
        if let url = URL(string: "https://api.appworks-school.tw/api/1.0/user/profile"){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let dataDict = jsonData["data"] as? [String: Any],
                       let name = dataDict["name"] as? String,
                       let pictureUrlString = dataDict["picture"] as? String,
                       let pictureUrl = URL(string: pictureUrlString) {
                        
                        DispatchQueue.main.async {
                            self.nameLabel.text = name
                            self.fbImage.kf.setImage(with: pictureUrl)
                        }
                    } else {
                        print("Failed to parse JSON")
                    }
                } catch {
                    print("JSONSerialization error: \(error.localizedDescription)")
                }
            }
            
            task.resume()
        }
    }
}
