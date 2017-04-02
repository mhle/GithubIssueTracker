//
//  IssueListViewController.swift
//  IssueViewer
//
//  Created by Michael Le on 02/04/2017.
//  Copyright © 2017 Michael Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class IssueListViewController: UIViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!

  let disposeBag = DisposeBag()
  var issueTrackerModel: IssueTrackerModel!
  var provider: RxMoyaProvider<Github>!
  var latestRepositoryName: Observable<String> {
    return searchBar.rx.text
      .orEmpty
      .debounce(0.5, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRx()
  }

  func setupRx() {
    // setup provider
    provider = RxMoyaProvider<Github>()
    
    // setup model
    issueTrackerModel = IssueTrackerModel(provider: provider, repositoryName: latestRepositoryName)
    
    // bind model to tableview
    issueTrackerModel
      .trackIssues()
      .bindTo(tableView.rx.items) { tableView, row, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: IndexPath(row: row, section: 0))
        cell.textLabel?.text = item.title
        return cell
      }
      .addDisposableTo(disposeBag)
    
    // hide keyboard if clicking on cell
    tableView.rx.itemSelected
      .subscribe(onNext: { [unowned self] _ in
        if self.searchBar.isFirstResponder {
          self.view.endEditing(true)
        }
      })
      .addDisposableTo(disposeBag)
  }


}

