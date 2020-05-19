//
//  DetailedViewController.swift
//  GitHub Search
//
//  Created by Emil Vaklinov on 19/05/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import UIKit
import CoreData
import WebKit


typealias RepoDetail = (String, String)
class DetailedViewController: UITableViewController {
    
    
    
    @IBOutlet var detailedTableView: UITableView!
    
    var selectedRepo: GitHubData?
    var content = [URL]()
    
    let coreDataStack = CoreDataStack.shared
    
    var items: [Items] = []
    
    var repoDetails: [RepoDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailedTableView.estimatedRowHeight = 80.00
        detailedTableView.rowHeight = UITableView.automaticDimension
       

    }
    
    
    
    func details() -> [(String, String)] {
        var items: [(String, String)] = []
        
        
        if let name = selectedRepo?.fullname,
            let language = selectedRepo?.language,
            let desc = selectedRepo?.desc,
            let openIssues = selectedRepo?.openIssues,
            let forks = selectedRepo?.forks,
            let watchers = selectedRepo?.watchers,
            let htmlUrl = selectedRepo?.htmlUrl
        {
            let titleName = "\(name) is a repository written in the \(language)"
            items.append(("Statement", titleName))
            items.append(("",desc))
            items.append(("Open Issues:", openIssues))
            items.append(("Forks:", forks))
            items.append(("Watchers:", watchers))
            items.append(("URL:", htmlUrl))
            
        }
        
        return items
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch section {
            
        // For the user details, return the count of the array
        case 0: return details().count
        case 1: return 1
        default: return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            
            // Dequeue the cell to display the user details
            let cell = detailedTableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
            
            // Decompose the tuple
            let type = details()
            
            // Set the values using the tuple
            cell.textLabel?.text = type[indexPath.row].0
            cell.detailTextLabel?.text = type[indexPath.row].1
            
            // Fetch the avatar
            guard let avatar = selectedRepo?.avatar else {return cell}
            guard let url = URL(string: avatar) else {return cell}
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                
                // UI Update = Main Queue
                DispatchQueue.main.async() {
                    if indexPath.row == 0{
                        cell.textLabel?.text = nil
                        cell.imageView?.image = UIImage(data: data)
                        cell.detailTextLabel?.text = type[indexPath.row].1
                    }  else {
                        
                        // Clear the ImageView in case we reuse it
                        cell.imageView?.image = nil
                    }
                    cell.setNeedsLayout()
                }
                if indexPath.section == 0 && indexPath.row == 0 {
                    cell.detailTextLabel?.textColor = .orange
                }
                if indexPath.section == 0 && indexPath.row == 1 {
                    cell.detailTextLabel?.textColor = .black            }
            }
            if indexPath.section == 0 && indexPath.row == 2 {
                cell.detailTextLabel?.textColor = .blue
            }
            if indexPath.section == 0 && indexPath.row == 3 {
                cell.detailTextLabel?.textColor = .blue
            }
            if indexPath.section == 0 && indexPath.row == 4 {
                cell.detailTextLabel?.textColor = .blue
            }
            if indexPath.section == 0 && indexPath.row == 5 {
                cell.detailTextLabel?.textColor = .blue
            }
            task.resume()
            
            return cell
            
            
        case 1:
            let cell = detailedTableView.dequeueReusableCell(withIdentifier: "webCell", for: indexPath) as! WebViewCell
            
            guard let htmlURLString = selectedRepo?.fullname else {return cell}
            var url: URL? {
                var components = URLComponents()
                components.scheme = "https"
                components.host = "github.com"
                components.path = "/\(htmlURLString)/blob/master/README.md"
                return components.url
            }
           
            
            guard let finalUrl = url else {return cell}
            let requestObject = URLRequest(url: finalUrl)
            cell.webView.load(requestObject)

            
    
            return cell
        
        default: return UITableViewCell()
            
        }
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0: return 55
        case 1: return 600
        default: return 0
        }
    }
    
    
    override  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0: return "User Repo"
        case 1: return "Web View"
        default: return nil
        }
        
    }
    
}
    

