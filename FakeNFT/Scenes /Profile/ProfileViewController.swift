//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Soslan Dzampaev on 08.11.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewProtocol {
    // MARK: - Private Properties
    private var presenter: ProfilePresenter?
    
    private lazy var editButton: UIButton = {
        let editButton = UIButton(type: .system)
        editButton.setImage(UIImage(named: "editButton"), for: .normal)
        editButton.tintColor = UIColor(named: "nftBlack")
        editButton.addTarget(self, action: #selector(didEditButtonTapped), for: .touchUpInside)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        return editButton
    }()
    
    private lazy var profileImageLogo: UIImageView = {
        let profileImageLogo = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        profileImageLogo.tintColor = .gray
        profileImageLogo.layer.cornerRadius = 35
        profileImageLogo.clipsToBounds = true
        profileImageLogo.translatesAutoresizingMaskIntoConstraints = false
        return profileImageLogo
    }()
    
    private lazy var usernameTitle: UILabel = {
        var usernameTitle = UILabel()
        usernameTitle.text = "User Name"
        usernameTitle.font = .headline3
        usernameTitle.textColor = UIColor(named: "nftBlack")
        usernameTitle.translatesAutoresizingMaskIntoConstraints = false
        return usernameTitle
    }()
    
    private lazy var stackViewWithTitleAndIcon: UIStackView = {
        let stackViewWithTitleAndIcon = UIStackView(arrangedSubviews: [profileImageLogo, usernameTitle])
        stackViewWithTitleAndIcon.axis = .horizontal
        stackViewWithTitleAndIcon.spacing = 16
        stackViewWithTitleAndIcon.translatesAutoresizingMaskIntoConstraints = false
        return stackViewWithTitleAndIcon
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .caption2
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 4
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textColor = UIColor(named: "nftBlack")
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var linkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("username.com", for: .normal)
        button.titleLabel?.font = .caption1
        button.titleLabel?.textColor = UIColor(named: "nftBlue")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Life View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter = ProfilePresenter(view: self)
        presenter?.loadProfileData()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateProfileUI(_:)),
                                               name: .profileUpdated,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .profileUpdated, object: nil)
    }
    
    // MARK: - Setup Methods
    private func setupView(){
        addSubviews()
        addConstraints()
        let editBarButtonItem = UIBarButtonItem(customView: editButton)
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    private func addSubviews(){
        view.addSubview(editButton)
        view.addSubview(profileImageLogo)
        view.addSubview(usernameTitle)
        view.addSubview(stackViewWithTitleAndIcon)
        view.addSubview(descriptionLabel)
        view.addSubview(linkButton)
        view.addSubview(tableView)
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            editButton.widthAnchor.constraint(equalToConstant: 42),
            editButton.heightAnchor.constraint(equalToConstant: 42),
            
            profileImageLogo.widthAnchor.constraint(equalToConstant: 70),
            profileImageLogo.heightAnchor.constraint(equalToConstant: 70),
            
            stackViewWithTitleAndIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            stackViewWithTitleAndIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackViewWithTitleAndIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: stackViewWithTitleAndIcon.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            linkButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            linkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 162)
        ])
    }
    
    // MARK: - Private methods
    @objc
    private func didEditButtonTapped(){
        let editProfileInfoVC = EditProfileInfoViewController()
        present(editProfileInfoVC, animated: true)
    }
    
    @objc
    private func updateProfileUI(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let updatedProfile = userInfo["updatedProfile"] as? Profile {
            updateUI(with: updatedProfile)
        }
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func updateUI(with profile: Profile) {
        usernameTitle.text = profile.name
        descriptionLabel.text = profile.description
        linkButton.setTitle(profile.website, for: .normal)
        if let avatarUrlString = profile.avatar, let url = URL(string: avatarUrlString) {
            profileImageLogo.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.circle.fill"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProfileTableViewCell else {
            return ProfileTableViewCell()
        }
        
        cell.tintColor = UIColor(named: "nftBlack")
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.setTitleLabel(text: "Мои NFT (\(presenter?.getNFTCount() ?? 0))")
        case 1:
            cell.setTitleLabel(text: "Избранные NFT (\(presenter?.getLikesCount() ?? 0))")
        case 2:
            cell.setTitleLabel(text: "О разработчике")
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let myNFTViewController = MyNFTViewController()
            navigationController?.pushViewController(myNFTViewController, animated: true)
        case 1:
            let favouriteViewController = FavouritesViewController()
            navigationController?.pushViewController(favouriteViewController, animated: true)
        case 2:
            if let urlString = linkButton.titleLabel?.text,
               let url = URL(string: urlString) {
                let profileSiteViewController = ProfileSiteViewController(websiteURL: url)
                navigationController?.pushViewController(profileSiteViewController, animated: true)
            }
        default:
            break
        }
    }
    
}
