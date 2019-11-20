//
//  OneItem.swift
//  XMLTest
//
//  Created by Elizaveta Prokudina on 18.11.2019.
//  Copyright © 2019 Elizaveta Prokudina. All rights reserved.
//

import UIKit


class OneItemViewController: UIViewController {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemFullText: UILabel!
    
    var oneItem: NewsItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        itemTitle.text = oneItem.itemTitle
        itemFullText.text = oneItem.itemFullText
        
        DispatchQueue.main.async {
            if let data = try? Data(contentsOf: self.oneItem.itemImgUrl!) {
                
                self.itemImage?.image = UIImage(data: data)
            }
        }
    }
}


