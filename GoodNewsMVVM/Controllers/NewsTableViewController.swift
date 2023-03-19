//
//  NewsTableViewController.swift
//  GoodNewsMVVM
//
//  Created by BoMin on 2023/03/12.
//

import UIKit
import RxSwift

class NewsTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    private var articleListVM: ArticleListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = UIColor(displayP3Red: 87 / 255, green: 101 / 255, blue: 116 / 255, alpha: 1.0)
        self.tableView.backgroundColor = UIColor(displayP3Red: 87 / 255, green: 101 / 255, blue: 116 / 255, alpha: 1.0)
        
        populateNews()
    }
    
    private func populateNews() {
        
        let resource = Resource<ArticlesList>(url: URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=b85fd2ea4fda4570a2cd9e191a05f021")!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { articleResponse in
                
                let articles = articleResponse.articles
                
                self.articleListVM = ArticleListViewModel(articles)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.articleListVM == nil ? 0: self.articleListVM.articlesVM.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("Article TableView Cell not found.")
        }
        
        let articleVM = self.articleListVM.articleAt(indexPath.row)
        
        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        articleVM.description.asDriver(onErrorJustReturn: "")
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        cell.backgroundColor = UIColor(displayP3Red: 87 / 255, green: 101 / 255, blue: 116 / 255, alpha: 1.0)
        
        return cell
    }

}
