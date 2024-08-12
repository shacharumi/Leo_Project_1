import UIKit
import Kingfisher
import IQKeyboardManagerSwift
import StatusAlert
import CoreData

class DetailViewController: UIViewController,CartVCCellDelegate {
    
    
    var data: Datum?
    let tableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    let imageView = UIImageView()
    let buttonView = UIView()
    let viewInit = TouchButton()
    let addCartView = UITableView()
    let grayOverlay = UIView()
    var cartViewBackButton = UIButton()
    var isExpanded = false
    var status = false
    var addCartViewHeightConstraint: NSLayoutConstraint!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectColor : String = ""
    var selectSize : String = ""
    var selectNumber : Int =  0
    var sizeSum : Int = 0
    var colorName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setUpTableView()
        setupTableHeaderView()
        setUpButtonView()
        createTouchButtonView()
        setUpGrayOverlay()
        setUpImages()
        pageControl.numberOfPages = data?.images.count ?? 0
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func setUpTableView() {
        tableView.isUserInteractionEnabled = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailVCCell.self, forCellReuseIdentifier: "DetailVCCell")
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
       
        let backButton = viewInit.backButton()
        view.addSubview(tableView)
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setupTableHeaderView() {
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 500))
        headerView.addSubview(scrollView)
        scrollView.contentInsetAdjustmentBehavior = .never
        headerView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: headerView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            pageControl.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
        tableView.tableHeaderView = headerView
    }
}


extension DetailViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return 9
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailVCCell", for: indexPath) as! DetailVCCell
            cell.configure(for: indexPath, data: data!)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = addCartView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartVCCell
            cell.configure(for: indexPath, data: data!)
            cell.cartDelegate = self
            cell.selectionStyle = .none
            cartViewBackButton = cell.backImage
            cartViewBackButton.addTarget(self, action: #selector(collapseAddCartView), for: .touchUpInside)
            return cell
        }
    }
}

extension DetailViewController {
    // MARK: -popup addCartView
    func createTouchButtonView() {
        addCartView.allowsSelection = true
        addCartView.backgroundColor = .white
        addCartView.translatesAutoresizingMaskIntoConstraints = false
        addCartView.rowHeight = UITableView.automaticDimension
        addCartView.estimatedRowHeight = 100
        addCartView.register(CartVCCell.self, forCellReuseIdentifier: "CartTableViewCell")
        view.addSubview(addCartView)
    }
    
    func setUpButtonView() {
        let button = viewInit.button()
        buttonView.addSubview(button)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView)
        button.addTarget(self, action: #selector(expandView), for: .touchUpInside)
        let topBorder = viewInit.topBorder()
        buttonView.addSubview(topBorder)
        addCartView.delegate = self
        addCartView.dataSource = self
        addCartView.separatorStyle = .none
        
        view.addSubview(addCartView)
        addCartViewHeightConstraint = addCartView.heightAnchor.constraint(equalToConstant: 0)
        addCartViewHeightConstraint.isActive = true
        
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
        
        NSLayoutConstraint.activate([
            addCartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addCartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addCartView.bottomAnchor.constraint(equalTo: buttonView.topAnchor),
            addCartViewHeightConstraint
        ])
    }
    
    
}

extension DetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.frame.width > 0 {
                let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
                if !pageIndex.isNaN && !pageIndex.isInfinite {
                    pageControl.currentPage = Int(pageIndex)
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.scrollView && !decelerate {
            adjustScrollViewPosition(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            adjustScrollViewPosition(scrollView)
        }
    }
    
    private func adjustScrollViewPosition(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let pageIndex = scrollView.contentOffset.x / pageWidth
        let targetPage: Int
        
        if pageIndex - floor(pageIndex) > 0.5 {
            targetPage = Int(ceil(pageIndex))
        } else {
            targetPage = Int(floor(pageIndex))
        }
        
        let offset = CGPoint(x: CGFloat(targetPage) * pageWidth, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        pageControl.currentPage = targetPage
    }
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        let pageIndex = sender.currentPage
        let offset = CGPoint(x: CGFloat(pageIndex) * scrollView.frame.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    func setUpMainImage() {
        guard let mainImageURL = data?.mainImage else { return }
        imageView.kf.setImage(with: URL(string: mainImageURL))
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 500),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 500)
        
    }
    
    func setUpImages() {
        guard let images = data?.images else { return }
        var previousImageView: UIImageView? = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            for i in 0..<images.count {
                DispatchQueue.main.async {
                    let imageView = UIImageView()
                    let url = images[i]
                    imageView.kf.setImage(with: URL(string: url))
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    self.scrollView.addSubview(imageView)
                    NSLayoutConstraint.activate([
                        imageView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: CGFloat(i) * self.view.frame.width),
                        imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
                        imageView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
                        imageView.heightAnchor.constraint(equalToConstant: 500)
                    ])
                    previousImageView = imageView
                }
            }
            
            DispatchQueue.main.async {
                if let lastImageView = previousImageView {
                    lastImageView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
                }
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * CGFloat(images.count), height: 500)
            }
        }
    }
}

extension DetailViewController {
    //MARK: popViewAction
    func setUpGrayOverlay() {
        grayOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        grayOverlay.translatesAutoresizingMaskIntoConstraints = false
        grayOverlay.isHidden = true
        view.addSubview(grayOverlay)
        
        NSLayoutConstraint.activate([
            grayOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            grayOverlay.bottomAnchor.constraint(equalTo: addCartView.topAnchor)
        ])
    }
    
   
    
    
    @objc func expandView() {
        if !isExpanded {
            grayOverlay.isHidden = false
            addCartViewHeightConstraint.constant = 448
            isExpanded = true
            status = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else if status == true && isExpanded == true {
            showSuccess()
            addCoreData()

            collapseAddCartView()
            reloadCell(at: IndexPath(row: 1, section: 0))
            
            let fetchRequest: NSFetchRequest<ShoppingCart> = ShoppingCart.fetchRequest()

//            do {
//                let cartItems = try context.fetch(fetchRequest)
//                for item in cartItems {
//                    print("Product: \(item.productName ?? ""), Color: \(item.productColor ?? ""), Size: \(item.productSize ?? ""), Count: \(item.productCount), Price: \(item.productPrice)")
//                }
//            } catch {
//                print("Failed to fetch items: \(error)")
//            }
        }
    }
    
    @objc func collapseAddCartView() {
        addCartViewHeightConstraint.constant = 0
        isExpanded = false
        grayOverlay.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func showSuccess() {
        let statusAlert = StatusAlert()
        statusAlert.image = UIImage(named: "Icons_44px_Success01")
        statusAlert.backgroundColor = .clear
        statusAlert.message = "加入成功"
        statusAlert.appearance.backgroundColor = .black
        statusAlert.appearance.tintColor = .white
        statusAlert.appearance.titleFont = UIFont.systemFont(ofSize: 15)
        statusAlert.sizesAndDistances.alertWidth = 175
        statusAlert.sizesAndDistances.minimumAlertHeight = 175
        statusAlert.canBePickedOrDismissed = true
        statusAlert.showInKeyWindow()
       
    }
    
    
    
    func UpdateStatus(_ status: Bool) {
        self.status = status
    }
    
    func reloadCell(at indexPath: IndexPath) {
        if let cell = addCartView.cellForRow(at: IndexPath(row: 1, section: 0)) as? CartVCCell {
            cell.currentSelectedBorder?.removeFromSuperview()
            cell.currentSelectedSizeBorder?.removeFromSuperview()
            cell.currentSelectedBorder = nil
            cell.currentSelectedSizeBorder = nil
            cell.plus.alpha = 0.5
            cell.numberView.alpha = 0.5
            cell.numberView.text = ""
            
        }
        addCartView.reloadRows(at: [indexPath], with: .automatic)
    }
    func cartData(_ color: String, _ size: String, _ count: Int, _ sizeSum: Int, _ colorName: String) {
        self.selectColor = color
        self.selectSize = size
        self.selectNumber = count
        self.sizeSum = sizeSum
        self.colorName = colorName
    }
    
    func addCoreData() {
        let newCartItem = ShoppingCart(context: context)
        newCartItem.productName = data?.title
        newCartItem.productColor = selectColor
        newCartItem.productSize = selectSize
        newCartItem.productCount = Int16(selectNumber)
        newCartItem.productImage = data?.mainImage
        let totalPrice = selectNumber*(data!.price)
        newCartItem.totalPrice = Int16(totalPrice)
        newCartItem.productPrice = Int16(data!.price)
        newCartItem.sizeSum = Int16(sizeSum)
        newCartItem.productId = Int64(data!.id)
        newCartItem.colorName = colorName
        
        
        do {
            try context.save()
            NotificationCenter.default.post(name: .shoppingCartUpdated, object: nil)
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
}
