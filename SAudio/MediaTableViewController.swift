//
//  MediaTableViewController.swift
//  SAudio
//
//  Created by Shahan Nedadahandeh on 2018-11-11.
//  Copyright © 2018 Shahan Nedadahandeh. All rights reserved.
//

import UIKit

class MediaTableViewController: UITableViewController {
    
    var fileURLs : [URL]?
    var fileChecks : [Bool]?
    let defaults = UserDefaults.standard
    var dirURL : URL?
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = FileManager.default
        fileChecks = [Bool]()
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if(fileURLs == nil){
            do {
                
                fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                
                

//                for (index, element) in fileURLs!.enumerated() {
//                    fileChecks![index]  = false
//                }
                
            } catch {
                print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
        }
         dirURL = fileURLs![0].deletingLastPathComponent()
        if(isKeyPresentInUserDefaults(key: (dirURL?.absoluteString)!)){
            fileChecks = defaults.array(forKey: (dirURL?.absoluteString)!) as? [Bool] ?? [Bool]()
        }else{
            for url in fileURLs!{
                //               / let fileName = url.lastPathComponent
                print(url);
                fileChecks?.append(false)
            }
        }

        
       
       
//        fileURLs!.sorted {$0.absoluteString.localizedStandardCompare($1) == .absoluteString.orderedAscending}
//        let sortedfileURLs = .sorted { $0.absoluteString < $1.absoluteString }
        let sortedfileURLs = fileURLs!.sorted {$0.absoluteString.localizedStandardCompare($1.absoluteString) == .orderedAscending}
        fileURLs = sortedfileURLs;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let foulderPath = fileURLs![0].deletingLastPathComponent()
        self.title = foulderPath.lastPathComponent
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        self.navigationItem.rightBarButtonItem = self.button
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fileURLs!.count
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(!directoryExistsAtPath(fileURLs![indexPath.row].absoluteString)){//checks if directory
            print("DIRECTORY EXIXTS AT PATH :" + fileURLs![indexPath.row].absoluteString)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AudioViewController") as! AudioViewController
            newViewController.MediaURL = fileURLs![indexPath.row]
            newViewController.hidesBottomBarWhenPushed = true
            newViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
//            newViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext // To show how / remove black backgorudn shit
            self.present(newViewController, animated: true, completion : nil)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MediaTableViewController")
            
            //self.present(vc, animated: true, completion : nil)
            do{
                let newfileURLs = try FileManager.default.contentsOfDirectory(at:fileURLs![indexPath.row], includingPropertiesForKeys: nil)
                let mediaVCTable = vc as? MediaTableViewController
                mediaVCTable?.fileURLs = newfileURLs
                self.navigationController?.pushViewController(vc, animated: true)
            }catch{
                print(error)
            }
            
        }

        
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MediaTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MediaTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            
        }
        let url = fileURLs![indexPath.row]
        var name = url.lastPathComponent
        if(!directoryExistsAtPath(url.absoluteString)){
            name.removeLast(4) // special conditions for normal files
            
        }else{
            name = "📂  " + name // special conditions for directories
        }
        if(fileChecks![indexPath.row] == true){
           cell.accessoryType = .checkmark
        }
        if(fileChecks![indexPath.row] == false){
            cell.accessoryType = .none
            cell.setNeedsDisplay()
            cell.setNeedsLayout()
        }
        
        let defaults = UserDefaults.standard
        defaults.set(fileChecks, forKey: (dirURL?.absoluteString)!)
        cell.NameLabel.text = name

        return cell
    }
 
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if(self.fileURLs![indexPath.item].absoluteString.last == "/"){// No editing for directories! yet...
            return [];
        }
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            //TODO: edit the row at indexPath here
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
            let originPath = self.fileURLs![indexPath.item] // used for renameing the file later
            let name = self.fileURLs![indexPath.item].absoluteString
            let lastpartname = NSString(string: name).lastPathComponent
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                var displayTextfieldText = self.fileURLs![indexPath.item].lastPathComponent
                if(displayTextfieldText.last != "/"){
//                     displayTextfieldText.removeLast(4)
                }
               
                textField.text = displayTextfieldText
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
//                print("Text field: \(String(describing: textField.text))")
       
                
                
                var newpath = name.replacingOccurrences(of: lastpartname, with: "")
                newpath.append(textField.text!)
                newpath = newpath.replacingOccurrences(of: " ", with: "%20")
                print(newpath)
                self.fileURLs![indexPath.item] = URL(string: newpath)!;
                tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                
                do {
                  
                    //Rename the file
                    let destinationPath = URL(string: newpath)!;
                    try FileManager.default.moveItem(at: originPath, to: destinationPath)
                } catch {
                    print(error)
                }
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            //TODO: Delete the row at indexPath here
//            self.fileURLs.remove(at: indexPath.item) // NO SECTIONS SUPPOR!
//            tableView.deleteRows(at: [indexPath], with: .fade)
            let alert = UIAlertController(title: "Delete", message: "Please delete media in Itunes!", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in }))
            self.present(alert, animated:true, completion: nil)
        }
        deleteAction.backgroundColor = .red
        
        return [editAction,deleteAction]
    }
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            if(self.fileChecks![indexPath.row] == true){
                self.fileChecks![indexPath.row] = false
            }
            else if(self.fileChecks![indexPath.row] == false){
                self.fileChecks![indexPath.row] = true
            }
            tableView.reloadRows(at: [indexPath], with: .none)
            success(true)
            
//            let cell = self.tableView(tableView, cellForRowAt: indexPath) as? MediaTableViewCell

            
            
        })
        tableView.reloadRows(at: [indexPath], with: .none)
        closeAction.image = UIImage(named: "check")
        closeAction.backgroundColor = .purple
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
/*
     //Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         //Return false if you do not want the specified item to be editable.
        return true
    }
    */

    

    

    
    // Overide to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let defaults = UserDefaults.standard
        defaults.set(fileChecks, forKey: (dirURL?.absoluteString)!)
        // Pass the selected object to the new view controller.
    }
 
     func directoryExistsAtPath(_ path: String) ->Bool {
       var newp = path
        if(newp.removeLast() == "/"){
            return true
        }else{
            return false
        }
    }
    
    
}
extension UserDefaults {
    func contains(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
