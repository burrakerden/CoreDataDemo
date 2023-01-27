//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Burak Erden on 24.01.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    // Reference to managed object content
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data for the table
    var items: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightBarButton()
        // Get item from Core Data
        fetchPeople()
    }
    
    
    // MARK: - FETCH DATA

    func fetchPeople() {
        // Fetch the data from Core Data to display in the tableView
        do {
            self.items = try context.fetch(Person.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("error-fetchPeople")
        }
        
    }
    
    
    
    
    
    private func rightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    }
    
    // MARK: - ADD NAME
    @objc func addItem() {
        let ac = UIAlertController(title: "Add Person", message: "Enter name", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            let textField = ac.textFields![0]
            
            // Create a new person object
            let newPerson = Person(context: self.context)
            
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.gender = "Male"
            
            // Save data
            do {
                try self.context.save()
            } catch {
                print("error-Save data")
            }
            
            // Re-fetch the data
            self.fetchPeople()
            
        }))
        self.present(ac, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = items![indexPath.row]
        cell.textLabel?.text = person.name
        return cell
    }
    // MARK: - EDIT NAME
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = items![indexPath.row]
        let alert = UIAlertController(title: "Edit", message: "Edit Name", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            let textfiedd = alert.textFields![0]
            person.name = textfiedd.text
            do {
                try self.context.save()
            } catch {
                
            }
            self.fetchPeople()
        }))
        self.present(alert, animated: true)
    }
    
    // MARK: - DELETE NAME
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            // Which person to remove
            let personToRemove = self.items![indexPath.row]
            
            // Remove the person
            self.context.delete(personToRemove)
            
            // Save data
            do {
                try self.context.save()
            } catch {
                print("error-Deleting data")
            }
            // Re-fetch data
            self.fetchPeople()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

