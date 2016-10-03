//
//  Protocols.swift
//  KyodaiGuideMapApp
//
//  Created by 丸谷 浩永 on 9/22/16.
//  Copyright © 2016 丸谷 浩永. All rights reserved.
//

import UIKit

protocol ResultViewController : UIPopoverPresentationControllerDelegate {
    func reloadFetchedData()
    var searchBar: UISearchBar {get set}
    var viewController : PopoverCriteriaViewController {get}
}

protocol SetFavoriteDelegate{
    func setFavorite(_ number: String, value: NSNumber)
}

protocol ModalViewControllerDelegate {
    func modalDidFinished()
    func modalResetTapped()
}

protocol TableViewCellDelegate {
    func calculateTime(_ coordinate : (longitude : Double, latitude : Double), indexPath: IndexPath)
}
