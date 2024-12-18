//
//  PaymentAssembly.swift
//  FakeNFT
//
//  Created by Pavel Bobkov on 16.11.2024.
//

import UIKit

public final class PaymentAssembly {

    private let servicesAssembler = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        nftCollectionCatalogueStorage: NftCollectionCatalogueStorageImpl()
    )

    public func build() -> UIViewController {
        let presenter = PaymentPresenter(
            paymentService: servicesAssembler.paymentService,
            deleteNftService: servicesAssembler.deleteNftService
        )
        let viewController = PaymentViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
