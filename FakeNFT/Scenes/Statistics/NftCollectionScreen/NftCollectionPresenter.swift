import Foundation

protocol NftCollectionPresenterProtocol: AnyObject {
    var view: NftCollectionViewControllerProtocol? { get set }
    var state: NftCollectionState { get set }
    func viewDidLoad()
    func getNftCount() -> Int
    func getNft(_ indexRow: Int) -> Nft
    func isLiked(_ indexRow: Int) -> Bool
    func isOrdered(_ indexRow: Int) -> Bool
    func tapCart(_ id: String, _ indexPath: IndexPath)
    func tapLike(_ id: String, _ indexPath: IndexPath)
}

enum NftCollectionState {
    case initial, loading, failed(Error), success
}

final class NftCollectionPresenter: NftCollectionPresenterProtocol {
    
    weak var view: NftCollectionViewControllerProtocol?
    
    private let nftModel: NftCollectionModelProtocol
    private let loggingService = LoggingService.shared
    
    private var isLoading: Bool = false
    
    var state = NftCollectionState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init
    init(nftModel: NftCollectionModelProtocol) {
        self.nftModel = nftModel
    }
    
    // MARK: - Methods
    func viewDidLoad() {
        nftModel.loadNfts()
        nftModel.loadLikes()
        nftModel.loadOrder()
    }
    
    func getNftCount() -> Int {
        nftModel.getNftCount()
    }
    
    func getNft(_ indexRow: Int) -> Nft {
        nftModel.getNft(indexRow)
    }
    
    func isLiked(_ indexRow: Int) -> Bool {
        nftModel.isLiked(indexRow)
    }
    
    func isOrdered(_ indexRow: Int) -> Bool {
        nftModel.isOrdered(indexRow)
    }
    
    func tapCart(_ id: String, _ indexPath: IndexPath) {
        nftModel.tapCart(id, indexPath)
    }
    
    func tapLike(_ id: String, _ indexPath: IndexPath) {
        nftModel.tapLike(id, indexPath)
    }
    
    func stateDidChanged() {
        switch state {
        case .initial:
            loggingService.logCriticalError("can't move to initial state")
        case .loading:
            view?.showLoading()
        case .success:
            view?.hideLoading()
            view?.updateCollectionView()
        case .failed(let error):
            handleLoadingError(error)
        }
    }
    
    private func handleLoadingError(_ error: Error) {
        let errorModel = makeErrorModel(error)
        view?.hideLoading()
        view?.showError(errorModel)
        isLoading = false
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
