//
//  NewsTableViewController.swift
//  XMLTest
//
//  Created by Elizaveta Prokudina on 19.11.2019.
//  Copyright © 2019 Elizaveta Prokudina. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var newsArray: [NewsItem]?
    let myUrl = URL(string: "https://www.vesti.ru/vesti.rss")
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Wait a second", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        tableView.refreshControl = myRefreshControl
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! newsCell
        if let itemsArray = newsArray {
            let item = itemsArray[indexPath.row]
            configureCell(cell: cell, item: item)
        }
        return cell
    }
    
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         performSegue(withIdentifier: "goToOneItem", sender: self)
     }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToOneItem" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as? OneItemViewController)?.oneItem = (newsArray?[indexPath.row])!
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
        
        //MARK: Functions
        
        func ChooseCategory(category: String) -> [NewsItem] {
            fetchData()
            var filteredArray: [NewsItem] = []
            for item in 0...newsArray!.count-1 {
                if newsArray![item].itemCategory == category {
                    filteredArray.append(newsArray![item])
                }
            }
            return  filteredArray
        }
    
    @objc func refresh(sender: UIRefreshControl) {
        fetchData()
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
            self.tableView.contentOffset = .zero
            sender.endRefreshing()
        }
    }
    
    func fetchData() {
        NewsParser.sharedInstance.parseNews(url: myUrl!) { (itemsArray) in
            self.newsArray = itemsArray
        }
    }
    
    //MARK: Filter
    
    @IBAction func Filter(_ sender: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex {
            
        case 0:
            fetchData()
            
        case 1:
           newsArray = ChooseCategory(category: "Общество")
            
        case 2:
            newsArray = ChooseCategory(category: "Происшествия")
            
        case 3:
            newsArray = ChooseCategory(category: "Спорт")
            
        case 4:
            newsArray = ChooseCategory(category: "Политика")
            
        default:
            break
        }
        tableView.reloadData()
    }
}

//MARK: Cell Configuration

class newsCell: UITableViewCell {
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsPubDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: Extension

extension TableViewController {
    
    func configureCell(cell: newsCell, item: NewsItem) {
        
        cell.newsTitle.text = item.itemTitle
        cell.newsPubDate.text = item.itemPubDate
    }
}
