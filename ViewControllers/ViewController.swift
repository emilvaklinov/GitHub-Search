//
//  ViewController.swift
//  GitHub Search
//
//  Created by Emil Vaklinov on 19/05/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
      let coreDataStack = CoreDataStack.shared
          
          
          override func viewDidLoad() {
              super.viewDidLoad()
              
              // Do any additional setup after loading the view.
              do {
                  try fetchedResultsController.performFetch()
              } catch {
                  print(error.localizedDescription)
              }
              
             
              
          }
          
          let apiManager = APIManager()
          var selectedIndexPath: IndexPath?
          
          
          var items: [Items] = []
          var gitHubData: [GitHubData] = []
 
          
          // var score = String(score.Double)
          
          let cellIdentifier = "SearchCell"
          
          func search(_ text: String) {
              
              apiManager.searchFor(text) { [unowned self] outcome in
                  
                  switch outcome {
                  case .failure(let errorString):
                      print(errorString)
                      
                  case .success(let data):
                      
                      do {
                          let result = try JSONParser.parse(data, type: GitHubRoot.self)
                          self.items = result.items
                          self.saveInCoreDataWith(array: [])
                          
                          DispatchQueue.main.async {
                              self.tableView.reloadData()
                              
                          }
                          
                      } catch {
                          print("JSON Error: \(error)")
                      }
                      
                  }
              }
          }
          
          
          private func saveInCoreDataWith(array: [Items]) {
              
              let container = coreDataStack.persistentContainer
              
              container.performBackgroundTask() { (context) in
                  for jsonObject in self.items {
                     // Fetching the duplicates
                      guard let allRepos = self.fetchedResultsController.fetchedObjects else {
                          fatalError("No result in fetchedResultsController")
                      }
                      //Filter the result
                      let matchedValue = allRepos.filter({ $0.id == jsonObject.id })
                      //Save the Data
                      if  matchedValue.count == 0 {
                      
                      let repoEntity = GitHubData(context: self.coreDataStack.mainContext)
                          
                      repoEntity.id = Int64(jsonObject.id)
                      repoEntity.name = jsonObject.name
                      repoEntity.fullname = jsonObject.fullname
                      repoEntity.htmlUrl = jsonObject.htmlUrl
                      repoEntity.avatar = jsonObject.owner.avatarUrl
                      repoEntity.desc = jsonObject.description
                      repoEntity.score = String(format: "%.2f", jsonObject.score)
                      repoEntity.openIssues = String(jsonObject.openIssues)
                      repoEntity.watchers = String(jsonObject.watchers)
                      repoEntity.forks = String(jsonObject.forks)
                      repoEntity.language = jsonObject.language
               //       print(repoEntity)
                  }
                  
                  do {
                      try self.coreDataStack.mainContext.save()
                  } catch {
                      fatalError("Failure to save context: \(error)")
                  }
          
              }
          }
          }
          lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<GitHubData> in
              
              // Create a request to fetch ALL
              let fetchRequest = GitHubData.fetchRequest() as NSFetchRequest<GitHubData>
              
              // Create sort decriptors to sort via age and Name
              let nameSort = NSSortDescriptor(key: "name", ascending: true)
              
              // Add the sort descriptors to the fetch request
              fetchRequest.sortDescriptors = [nameSort]
              
              // Set the batch size
              fetchRequest.fetchBatchSize = 10
              
              let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                   managedObjectContext: coreDataStack.mainContext,
                                                   sectionNameKeyPath: nil,
                                                   cacheName: nil)
              
              frc.delegate = self
              return frc
          }()
      }

      // Not active
      func removeDuplicates(array: [String]) -> [String] {
          var encountered = Set<String>()
          var result: [String] = []
          for value in array {
              if encountered.contains(value) {
                  // Do not add a duplicate element.
              }
              else {
                  // Add value to the set.
                  encountered.insert(value)
                  // ... Append the value.
                  result.append(value)
              }
          }
          return result
      }

      extension ViewController: UITableViewDelegate, UITableViewDataSource{
          
          func numberOfSections(in tableView: UITableView) -> Int {
              
              guard let sections = fetchedResultsController.sections else {
                  fatalError("No sections in fetchedResultsController")
              }
             // print("number of sections \(sections.count)")
              return sections.count
              
          }
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              
              guard let sections = fetchedResultsController.sections else {
                  fatalError("No sections in fetchedResultsController")
              }
              let sectionInfo = sections[section]
              
             // print("number of object \(sectionInfo.numberOfObjects)")
              navigationItem.title = "\(sectionInfo.numberOfObjects) '\(searchBar.text ?? "")' repos"
              return sectionInfo.numberOfObjects
          }
          
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              
              guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchCell  else {
                  fatalError("The dequeued cell is not an instance of TableViewCell.")
              }
              
              let currentItem = fetchedResultsController.object(at: indexPath)
              guard let score = currentItem.score else {return cell}
              
              cell.nameLabel.text = currentItem.fullname
              cell.titleLabel.text = currentItem.desc
              cell.scoreLabel.text = String("Score: \(score)")
              cell.languageLabel.text = currentItem.language
              navigationItem.title = "\(items.count) '\(searchBar.text ?? "")' repos"
              
              return cell
              
          }
          
          func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
              if editingStyle == .delete {
                  
                  let repo = fetchedResultsController.object(at: indexPath)
                  
                  fetchedResultsController.managedObjectContext.delete(repo)
                  
                  do {
                      try fetchedResultsController.managedObjectContext.save()
                  } catch {
                      print(error)
                  }
                  
              }
              
          }
          
      }



      //extension ViewController: UITableViewDelegate {}

      extension ViewController: UISearchBarDelegate {
          
          func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
              search(searchBar.text ?? "GitHubRepos")
          }
          
      }


      extension ViewController: NSFetchedResultsControllerDelegate{
          func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
              tableView.beginUpdates()
          }
          
          func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
              switch type {
              case .insert:
                  tableView.insertRows(at: [newIndexPath!], with: .fade)
              case .delete:
                  tableView.deleteRows(at: [indexPath!], with: .fade)
              case .update:
                  tableView.reloadRows(at: [indexPath!], with: .fade)
              case .move:
                  tableView.moveRow(at: indexPath!, to: newIndexPath!)
              @unknown default:
                fatalError()
            }
          }
          
          func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
              switch type {
              case .insert:
                  tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
              case .delete:
                  tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
              case .move:
                  break
              case .update: break
              @unknown default:
                fatalError()
                break
            }
          }
          
          
          func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
              tableView.endUpdates()
          }
          
          func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              selectedIndexPath = indexPath
              performSegue(withIdentifier: "showDetails", sender: tableView)
              tableView.deselectRow(at: indexPath, animated: true)
          }
          
          override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              if let nextViewController = segue.destination as? DetailedViewController,
                  let indexPath = selectedIndexPath {
                  let currentRepo = fetchedResultsController.object(at: indexPath)
                  nextViewController.selectedRepo = currentRepo
                  
              }
              
          }
         
      }

