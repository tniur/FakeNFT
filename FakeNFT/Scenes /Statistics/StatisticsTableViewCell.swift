//
//  StatisticsTableViewCell.swift
//  FakeNFT
//
//  Created by Юрий Гриневич on 09.11.2024.
//

import UIKit
import SnapKit

final class StatisticsTableViewCell: UITableViewCell, ReuseIdentifying {
    
    private lazy var backgroundGreyView: UIView = {
        let view = UIView()
        view.backgroundColor = .nftLightGrey
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingLabel, backgroundGreyView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var nameNftLabelStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, nftCountLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, nameNftLabelStack])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .regular15
        label.textAlignment = .center
        label.textColor = .nftBlack
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .bold22
        label.textColor = .nftBlack
        return label
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = .bold22
        label.textColor = .nftBlack
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        ratingLabel.text = "1"
        avatarImageView.image = UIImage(named: "profilePhoto")
        usernameLabel.text = "Username"
        nftCountLabel.text = "112"
    }
}

extension StatisticsTableViewCell: SettingViewsProtocol {
    func setupView() {
        backgroundColor = .clear
        addSubviews(mainStack)
        backgroundGreyView.addSubviews(contentStack)
        
        addConstraints()
    }
    
    func addConstraints() {
        mainStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        avatarImageView.snp.makeConstraints { make in
            make.height.width.equalTo(28)
        }
        
        contentStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(26)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        ratingLabel.snp.makeConstraints { make in
            make.width.equalTo(28)
        }
    }
}