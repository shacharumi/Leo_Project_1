import UIKit
import Alamofire
import Kingfisher
import MJRefresh

class CategoryView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CategoryMarketManagerDelegate {

    var categoryList: [Datum] = []
    let categoryMarketManager = ProductMarketManager()
    var nextPage: Int = 0
    var buttonPage: String?
    var isLoading: Bool = false
    var hasMoreData: Bool = true
    var cache: [String: (data: [Datum], nextPage: Int, hasMoreData: Bool)] = [:]
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var categoryVC: UICollectionView!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var underlineViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var underlineViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var underlineViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryVC.delegate = self
        categoryVC.dataSource = self
        categoryMarketManager.delegate = self
        self.view.bringSubviewToFront(underlineView)
        let noRecordStrNavigation = NSLocalizedString("型錄", comment: "")
        navigationBar.title = noRecordStrNavigation

        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (screenWidth - 48) / 2, height: screenWidth * 0.7)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16.0, bottom: 0, right: 16.0)
        layout.minimumLineSpacing = 25.0
        
        categoryVC.setCollectionViewLayout(layout, animated: false)
        let noRecordStrWoman = NSLocalizedString("女裝", comment: "")
        let noRecordStrMan = NSLocalizedString("男裝", comment: "")
        let noRecordStrAccessories = NSLocalizedString("配件", comment: "")
        buttonPage = "\(noRecordStrWoman)"
        firstButton.tintColor = .darkGray
        firstButton.setTitle(noRecordStrWoman, for: .normal)
        secondButton.tintColor = .lightGray
        secondButton.setTitle(noRecordStrMan, for: .normal)
        thirdButton.tintColor = .lightGray
        thirdButton.setTitle(noRecordStrAccessories, for: .normal)

        
        let buttons = buttonStackView.subviews
        for button in buttons {
            if let uibutton = button as? UIButton {
                uibutton.addTarget(self, action: #selector(changeCategory), for: .touchUpInside)
            }
        }
        
        fetchCategoryData(buttonPage: buttonPage ?? "", page: nextPage)

        // 配置 MJRefresh
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        categoryVC.mj_footer = footer
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
        categoryVC.mj_header = header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = categoryVC.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        
        let categoryProduct = categoryList[indexPath.row]
        if let url = URL(string: categoryProduct.mainImage) {
            cell.categoryImage.kf.setImage(with: url)
        }
        cell.categoryLabel.text = categoryProduct.title
        cell.categoryPriceLabel.text = String(categoryProduct.price)
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showDetailSegue2", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue2" {
            if let detailViewController = segue.destination as? DetailViewController {
                if let indexPath = sender as? IndexPath {
                    let product = categoryList[indexPath.row]
                    detailViewController.data = product
                }
            }
        }
    }
    
    // MARK: - CategoryMarketManagerDelegate
    
    func manager(_ manager: ProductMarketManager, didGet categoryData: PageJson) {
        if nextPage == 0 {
            self.categoryList = categoryData.pageData
        } else {
            self.categoryList.append(contentsOf: categoryData.pageData)
        }
        self.nextPage = categoryData.nextPaging ?? 0
        self.hasMoreData = categoryData.nextPaging != nil
        self.isLoading = false
        
        // 更新快取
        cache[buttonPage ?? ""] = (data: self.categoryList, nextPage: self.nextPage, hasMoreData: self.hasMoreData)
        
        DispatchQueue.main.async {
            self.categoryVC.reloadData()
            self.categoryVC.mj_header?.endRefreshing()
            if self.hasMoreData == true {
                self.categoryVC.mj_footer?.endRefreshing()
            } else {
                self.categoryVC.mj_footer?.endRefreshingWithNoMoreData()

            }
        }
    }
    
    func manager(_ manager: ProductMarketManager, didFailWith error: Error) {
        print("Failed to get marketing hots: \(error)")
        self.isLoading = false
        DispatchQueue.main.async {
            self.categoryVC.mj_header?.endRefreshing()
            self.categoryVC.mj_footer?.endRefreshing()
            self.categoryVC.mj_footer?.resetNoMoreData()
        }
    }

    func managerDidCancelRequest(_ manager: ProductMarketManager) {
        self.isLoading = false
        if let cachedData = cache[buttonPage ?? "0"] {
            self.categoryList = cachedData.data
            self.nextPage = cachedData.nextPage
            self.hasMoreData = cachedData.hasMoreData
            
            DispatchQueue.main.async {
                self.categoryVC.reloadData()
                self.categoryVC.mj_header?.endRefreshing()
                if self.hasMoreData == true {
                    self.categoryVC.mj_footer?.endRefreshing()
                } else {
                    self.categoryVC.mj_footer?.endRefreshingWithNoMoreData()
                }
            }
        } else {
            DispatchQueue.main.async {
                self.categoryVC.mj_header?.endRefreshing()
                if self.hasMoreData == true {
                    self.categoryVC.mj_footer?.endRefreshing()
                } else {
                    self.categoryVC.mj_footer?.endRefreshingWithNoMoreData()

                }
            }
        }
    }
    
    // MARK: - Fetch Category Data
    
    func fetchCategoryData(buttonPage: String, page: Int) {
        isLoading = true
        categoryMarketManager.delegateCategoryData(buttonPage: buttonPage, page: page)
    }
    
    // MARK: - Load More Data
    
    @objc func loadMoreData() {
        guard !isLoading && hasMoreData else {
            DispatchQueue.main.async {
                self.categoryVC.mj_footer?.endRefreshing()
            }
            return
        }
        isLoading = true
        fetchCategoryData(buttonPage: buttonPage ?? "", page: nextPage)
    }
    
    // MARK: - Refresh Data
    
    @objc func refreshData() {
        guard !isLoading else {
            DispatchQueue.main.async {
                self.categoryVC.mj_header?.endRefreshing()
            }
            return
        }
        nextPage = 0
        hasMoreData = true
        fetchCategoryData(buttonPage: buttonPage ?? "", page: nextPage)
    }
    
    // MARK: - Button Actions
    
    @objc func changeCategory(sender: UIButton) {
        guard let newCategory = sender.titleLabel?.text, newCategory != buttonPage else { return }
        
        categoryMarketManager.cancelCurrentRequest()
        
        buttonPage = newCategory
        firstButton.tintColor = .lightGray
        secondButton.tintColor = .lightGray
        thirdButton.tintColor = .lightGray
        
        underlineViewWidthConstraint.isActive = false
        underlineViewCenterXConstraint.isActive = false
        underlineViewTopConstraint.isActive = false
        
        underlineViewWidthConstraint = underlineView.widthAnchor.constraint(equalTo: sender.widthAnchor)
        underlineViewCenterXConstraint = underlineView.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
        underlineViewTopConstraint = underlineView.topAnchor.constraint(equalTo: sender.bottomAnchor)
        
        underlineViewWidthConstraint.isActive = true
        underlineViewCenterXConstraint.isActive = true
        underlineViewTopConstraint.isActive = true
        
        sender.tintColor = .darkGray
        
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.view.layoutIfNeeded()
        }.startAnimation()
        
        if let cachedData = cache[buttonPage ?? ""] {
            self.categoryList = cachedData.data
            self.nextPage = cachedData.nextPage
            self.hasMoreData = cachedData.hasMoreData
            self.categoryVC.reloadData()
        } else {
            nextPage = 0
            hasMoreData = true
            fetchCategoryData(buttonPage: buttonPage ?? "", page: nextPage)
        }
        
        self.categoryVC.mj_footer?.endRefreshingWithNoMoreData()
    }
}
