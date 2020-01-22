//
//  TaskTableViewController.swift
//  Assignment2_C0749456
//
//  Created by Megha Mahna on 2020-01-20.
//  Copyright © 2020 meghamahna. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController {
    
    @IBOutlet weak var sortByTitle: UIBarButtonItem!
    @IBOutlet weak var sortByDate: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
   
    
    var tasks: [Task]?
    var filteredData: [Task]?
    var addDay = "0"
    var curIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCoreData()
        filteredData = tasks!
        searchBar.delegate = self
        
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
     
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
               let task = filteredData![indexPath.row]
               let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell")
               cell?.textLabel?.text = task.title
        cell?.detailTextLabel?.text = "\(task.days) days + \(task.counter) completed days + \(task.date)"
        
                if task.counter == task.days{
                    cell?.backgroundColor = UIColor.green
                    cell?.textLabel?.text = "Completed"
                    cell?.detailTextLabel?.text = ""
                    
                }
               return cell!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let Addaction = UITableViewRowAction(style: .normal, title: "Add Day") { (rowaction, indexPath) in
                print("Add day")
                
                let alertcontroller = UIAlertController(title: "Add Day", message: "Enter a day for this task", preferredStyle: .alert)
                               
                               alertcontroller.addTextField { (textField ) in
                                               textField.placeholder = "number of days"
                                self.addDay = textField.text!
                                print(self.addDay)
                                
                                   textField.text = ""
                                
                               }
                               let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                               CancelAction.setValue(UIColor.brown, forKey: "titleTextColor")
                               let AddItemAction = UIAlertAction(title: "Add Item", style: .default){
                                   (action) in
                                let count = alertcontroller.textFields?.first?.text
                                self.filteredData?[indexPath.row].counter += Int(count!) ?? 0
                                
                                if self.filteredData?[indexPath.row].counter == self.filteredData?[indexPath.row].days{
                                    
                                    print("equal")


                                    }
                                    
                                
                            
                                self.tableView.reloadData()
                                
                        
                    }
                        AddItemAction.setValue(UIColor.black, forKey: "titleTextColor")
                                             alertcontroller.addAction(CancelAction)
                                             alertcontroller.addAction(AddItemAction)
                                             self.present(alertcontroller, animated: true, completion: nil)
            }
            Addaction.backgroundColor = UIColor.blue
            
    
            let deleteaction = UITableViewRowAction(style: .normal, title: "Delete") { (rowaction, indexPath) in
                
                
                      // let taskItem = self.tasks![indexPath.row] as? NSManagedObject
                       let appDelegate = UIApplication.shared.delegate as! AppDelegate
                       let ManagedContext = appDelegate.persistentContainer.viewContext
                       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
                do{
                    let test = try ManagedContext.fetch(fetchRequest)
                    let item = test[indexPath.row] as? NSManagedObject
                    self.filteredData?.remove(at: indexPath.row)
                    self.tasks?.remove(at: indexPath.row)
                    ManagedContext.delete(item!)
                    tableView.reloadData()
                    
                    do{
                                try ManagedContext.save()
                        }
                
                    catch{
                                       print(error)
                                   }
                }
                catch{
                    print(error)
                }
                       
                    

            }
                   deleteaction.backgroundColor = UIColor.red
                   return [Addaction,deleteaction]
        }

        
 

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let detailView = segue.destination as? TaskViewController{
            detailView.taskTable = self
            detailView.tasks = tasks
            
            if let tableViewCell = sender as? UITableViewCell{
                if let index = tableView.indexPath(for: tableViewCell)?.row{
                    detailView.titleString = filteredData![index].title
                    detailView.dayString = String(filteredData![index].days)
                    curIndex = index
                }
            }
            
       }
    
    }
    
    func loadCoreData(){
        tasks = [Task]()
         //create an instance of app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                // context
                let ManagedContext = appDelegate.persistentContainer.viewContext
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
        
         do{
             let results = try ManagedContext.fetch(fetchRequest)
             if results is [NSManagedObject]{
                 for result in results as! [NSManagedObject]{
                     let title = result.value(forKey:"title") as! String
                     let days = result.value(forKey: "days") as! Int
                    // let counter = result.value(forKey: "counter") as! Int
                     let date = result.value(forKey: "date") as? String
                     


                    tasks?.append(Task(title: title, days: days, date: date ?? ""))
                     tableView.reloadData()
                 }
             }
         } catch{
             print(error)
         }
         print(tasks!.count )
        tableView.reloadData()
    }
    
   
    
    func updateText(taskArray: [Task]){
        self.tasks = taskArray
        tableView.reloadData()
    }
    

    @IBAction func sortByTitle(_ sender: UIBarButtonItem) {
        
        let itemSort = self.filteredData!
                   self.filteredData! = itemSort.sorted { $0.title < $1.title }
                      self.tableView.reloadData()
    }
    
    
    @IBAction func sortByDate(_ sender: UIBarButtonItem) {
        
     let itemSort = self.filteredData!
     self.filteredData! = itemSort.sorted { $0.date < $1.date }
        self.tableView.reloadData()
    }
    
}

extension TaskTableViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = searchText.isEmpty ? tasks : tasks?.filter({ (item: Task) -> Bool in
            return item.title.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filteredData = tasks!
        tableView.reloadData()
    }
}
