//
//  XMLParser.swift
//  XMLTest
//
//  Created by Elizaveta Prokudina on 19.11.2019.
//  Copyright © 2019 Elizaveta Prokudina. All rights reserved.
//

import UIKit



class NewsParser: NSObject, XMLParserDelegate {
    
      static let sharedInstance = NewsParser()
    
var newsArray: [NewsItem] = []
     var elementName: String = String()
     
     var itemTitle = String()
     var itemPubDate = String()
     var itemCategory = String()
     var itemFullText = String()
     
     var postImgUrl: URL?
    
    private var parserCompletionHandler: (([NewsItem]) -> Void)?
    
    func parseNews(url: URL, completionHandler: (([NewsItem]) -> Void)?) {
        
        // Clear the array before updating with new news elements
        self.newsArray.removeAll()
        
        self.parserCompletionHandler = completionHandler
      
        if let parser = XMLParser(contentsOf: url) {
            parser.delegate = self
            parser.parse()
        }
    
    }
    
       func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            
            if elementName == "item" {
                itemTitle = String()
                itemPubDate = String()
                itemCategory = String()
                itemFullText = String()
            } else if elementName == "enclosure" {
                     if let urlString = attributeDict["url"] {
                         postImgUrl = URL(string: urlString)
                     }
                 }
             self .elementName = elementName
            }
               
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            
              if elementName == "item" {
                
                let item = NewsItem(itemTitle:  itemTitle, itemPubDate: itemPubDate, itemCategory: itemCategory, itemImgUrl: postImgUrl, itemFullText: itemFullText)
                
                  newsArray.append(item)
              }
          }
        
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            
            let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
             if (!data.isEmpty) {
                     if self.elementName == "title" {
                       itemTitle += data
                        
                }  else if self.elementName == "pubDate" {
                               itemPubDate += data
                        
                } else if self.elementName == "category" {
                                itemCategory += data
                        
                } else if self.elementName == "yandex:full-text" {
                               itemFullText += data
                }
            }
        }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(newsArray)
    }
    
}
