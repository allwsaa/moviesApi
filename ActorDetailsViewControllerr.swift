import UIKit
import SnapKit

class ActorDetailsViewController: UIViewController {
    private let actorId: Int
    private let bioLabel = UILabel()

    init(actorId: Int) {
        self.actorId = actorId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchActorDetails()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Actor Details"
        
        bioLabel.numberOfLines = 0
        bioLabel.font = .systemFont(ofSize: 16)
        view.addSubview(bioLabel)
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func fetchActorDetails() {
        NetworkingManager.shared.getActorDetails(for: actorId) { [weak self] actor in
            DispatchQueue.main.async {
                self?.title = actor?.name
                self?.bioLabel.text = actor?.biography
            }
        }
    }
}
