//
//  TaskViewController.swift
//  Assignment2_C0749456
//
//  Created by Megha Mahna on 2020-01-20.
//  Copyright © 2020 meghamahna. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    var tasks: [Task]?
    
    weak var taskTable: TaskTableViewController?
    
    @IBOutlet var dataItems: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       // loadCoreData()
        saveCoreData()
        NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        let title = dataItems[0].text ?? ""
        let days = Int(dataItems[1].text ?? "0") ?? 0
                   
                
        let task = Task(title: title, days: days)
        tasks?.append(task)
                   for textField in dataItems {
                       textField.text = ""
                       textField.resignFirstResponder()
                   }
    }
    
    @objc func saveCoreData(){
        
       // call clear core data
        clearCoreData()
        
        //create an instance of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               
                           // context
                           let ManagedContext = appDelegate.persistentContainer.viewContext
               
                           for task in tasks!{
                               let taskEntity = NSEntityDescription.insertNewObject(forEntityName: "TaskModel", into: ManagedContext)
                              taskEntity.setValue(task.title, forKey: "title")
                              taskEntity.setValue(task.days, forKey: "days")
               
                               print("\(task.days)")
                               //save  context
                               do{
                                   try ManagedContext.save()
                               }catch{
                                   print(error)
                               }
               
               
                               print("days: \(task.days)")
                           }
        loadCoreData()
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
                    
                 }
             }
         } catch{
             print(error)
         }
         print(tasks!.count )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          
           taskTable?.updateText(taskArray: tasks!)
           //taskTable?.updateTask(task: task1!)
    
       }
    
    func clearCoreData(){
        
    
     //create an instance of app delegate
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     
     // context
     let ManagedContext = appDelegate.persistentContainer.viewContext
        
        //create fetch request
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
        
        fetchRequest.returnsObjectsAsFaults = false
        do{
            
            let results = try ManagedContext.fetch(fetchRequest)
            for managedObjects in results{
                if let managedObjectsData = managedObjects as? NSManagedObject{
                    
                    ManagedContext.delete(managedObjectsData)
                }
            }
        }
            catch{
                print(error)
            }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
