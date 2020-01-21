//
//  TaskTableViewController.swift
//  Assignment2_C0749456
//
//  Created by Megha Mahna on 2020-01-20.
//  Copyright © 2020 meghamahna. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentControl: UIBarButtonItem!
    
    var tasks: [Task]?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        self.loadCoreData()
        //self.LoadData()
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
        return tasks?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = tasks![indexPath.row]
               let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell")
               cell?.textLabel?.text = task.title
               cell?.detailTextLabel?.text = "\(task.days) days"
               return cell!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let Addaction = UITableViewRowAction(style: .normal, title: "Add Day") { (rowaction, indexPath) in
                print("add day clicked")
            }
            Addaction.backgroundColor = UIColor.blue
            
            
            let deleteaction = UITableViewRowAction(style: .normal, title: "Delete") { (rowaction, indexPath) in
                
                
                      // let taskItem = self.tasks![indexPath.row] as? NSManagedObject
                       let appDelegate = UIApplication.shared.delegate as! AppDelegate
                       let ManagedContext = appDelegate.persistentContainer.viewContext
                       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
                do{
                    let test = try ManagedContext.fetch(fetchRequest)
                    let item = test[indexPath.row] as!NSManagedObject
                    self.tasks?.remove(at: indexPath.row)
                    ManagedContext.delete(item)
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
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let detailView = segue.destination as? TaskViewController{
            detailView.taskTable = self
            detailView.tasks = tasks
            
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


                     tasks?.append(Task(title: title, days: days))
                     tableView.reloadData()
                 }
             }
         } catch{
             print(error)
         }
         print(tasks!.count )
    }
    
    func LoadData(){
        
        //create an instance of app delegate
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               
               // context
               let ManagedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
        
        do{
            tasks = try ManagedContext.fetch(fetchRequest) as? [Task]
            self.tableView.reloadData()
            
        }catch
        {
            print("error")
        }

    }
    
    func updateText(taskArray: [Task]){
        tasks = taskArray
        tableView.reloadData()
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if !searchText.isEmpty {
//            var predicate: NSPredicate = NSPredicate()
//            predicate = NSPredicate(format: "title contains[c] '\(searchText)'")
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//            let ManagedContext = appDelegate.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"TaskModel")
//            fetchRequest.predicate = predicate
//            do {
//                tasks = try ManagedContext.fetch(fetchRequest) as? [Task]
//            } catch let error as NSError {
//                print("Could not fetch. \(error)")
//            }
//        }
//        tableView.reloadData()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "title contains %@", "\(searchText)")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let ManagedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
            fetchRequest.predicate = predicate
            do{
                tasks = try ManagedContext.fetch(fetchRequest) as? [Task]
            }
            catch{
                print("error")
            }
        }
        tableView.reloadData()
    }

}
