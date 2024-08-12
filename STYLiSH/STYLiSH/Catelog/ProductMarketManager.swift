import Alamofire
import MJRefresh
protocol CategoryMarketManagerDelegate: AnyObject {
    func manager(_ manager: ProductMarketManager, didGet categoryData: PageJson)
    func manager(_ manager: ProductMarketManager, didFailWith error: Error)
    func managerDidCancelRequest(_ manager: ProductMarketManager)
}
// MARK: - ProductMarketManager
class ProductMarketManager {
    weak var delegate: CategoryMarketManagerDelegate?
    private var currentRequest: DataRequest?

    func fetchCategoryData(buttonPage: String, page: Int, completion: @escaping (Result<PageJson, Error>) -> Void) {
        var url: String = ""
        let noRecordStrWoman = NSLocalizedString("女裝", comment: "")
        let noRecordStrMan = NSLocalizedString("男裝", comment: "")
        let noRecordStrAccessories = NSLocalizedString("配件", comment: "")
        
        if buttonPage == noRecordStrWoman {
            url = "https://api.appworks-school.tw/api/1.0/products/women?paging=\(page)"
        } else if buttonPage == noRecordStrMan {
            url = "https://api.appworks-school.tw/api/1.0/products/men?paging=\(page)"
        } else if buttonPage == noRecordStrAccessories {
            url = "https://api.appworks-school.tw/api/1.0/products/accessories?paging=\(page)"
        }
        
        currentRequest = AF.request(url).responseDecodable(of: PageJson.self) { response in
            switch response.result {
            case .success(let categoryJson):
                completion(.success(categoryJson))
            case .failure(let error):
                if let afError = error.asAFError, afError.isExplicitlyCancelledError {
                    self.delegate?.managerDidCancelRequest(self)
                } else {
                    completion(.failure(error))
                }
            }
        }
    }

    func cancelCurrentRequest() {
        currentRequest?.cancel()
        currentRequest = nil
        
    }

    func delegateCategoryData(buttonPage: String, page: Int) {
        cancelCurrentRequest()
        fetchCategoryData(buttonPage: buttonPage, page: page) { result in
            switch result {
            case .success(let categoryData):
                self.delegate?.manager(self, didGet: categoryData)
            case .failure(let error):
                print("Error: \(error)")
                self.delegate?.manager(self, didFailWith: error)
            }
        }
    }
}
