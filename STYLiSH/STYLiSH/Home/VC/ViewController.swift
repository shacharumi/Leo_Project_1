import UIKit
import Kingfisher
import MJRefresh
import CoreData

class ViewController: UIViewController, HomeMarketManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var productLists: [HomeData] = []
    let marketManager = HomeMarketManager()
    var dataSource: UITableViewDiffableDataSource<Int, Datum>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDataSource()
        marketManager.fetchMarketingHots()
    }
    
    // MARK: --segue data
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showDetailSegue", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            if let detailViewController = segue.destination as? DetailViewController {
                if let indexPath = sender as? IndexPath {
                    let product = productLists[indexPath.section].products[indexPath.row]
                    detailViewController.data = product
                }
            }
        }
    }
    
    // MARK: -ManagerProtocol
    func manager(_ manager: HomeMarketManager, didGet homeJsonData: HomeJson) {
        self.productLists = homeJsonData.data
        applySnapshot()
    }
    
    func manager(_ manager: HomeMarketManager, didFailWith error: Error) {
        print("Failed to get marketing hots: \(error)")
    }
    
    // MARK: - tableView
    func setupTableView() {
        self.view.bringSubviewToFront(tableView)
        tableView.isUserInteractionEnabled = true
        tableView.delegate = self
        marketManager.delegate = self
        MJRefreshConfig.default.languageCode = "en"
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
        tableView.allowsSelection = true
    }
    
    // MARK: - Setup DataSource
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Datum>(tableView: tableView) { tableView, indexPath, product in
            if indexPath.row % 2 == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
                let url = URL(string: product.mainImage)
                cell.firstCellImage.kf.setImage(with: url)
                cell.firstLabel.text = product.title
                cell.secondLabel.text = product.description
                cell.thirdLabel.text = " "
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! TableViewCell
                var url = URL(string: product.images[0])
                cell.secondLeftImage.kf.setImage(with: url)
                url = URL(string: product.images[1])
                cell.secondUpImage.kf.setImage(with: url)
                url = URL(string: product.images[2])
                cell.secondDownImage.kf.setImage(with: url)
                url = URL(string: product.images[3])
                cell.secondRightImage.kf.setImage(with: url)
                cell.sFirstLabel.text = product.title
                cell.sSecondLabel.text = product.description
                cell.sthirdLabel.text = " "
                return cell
            }
        }
    }
    
    // MARK: - Apply Snapshot
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Datum>()
        for (index, section) in productLists.enumerated() {
            snapshot.appendSections([index])
            snapshot.appendItems(section.products)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Pull down refresh
    @objc func refreshData() {
        DispatchQueue.main.async {
            self.marketManager.fetchMarketingHots()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.mj_header?.endRefreshing()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return productLists.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        let headerLabel = UILabel()
        headerLabel.text = productLists[section].title
        headerLabel.textColor = .black
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        return headerView
    }
}
