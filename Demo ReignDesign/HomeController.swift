//
//  HomeController.swift
//  Demo ReignDesign
//
//  Created by Daniel López  on 11-09-17.
//  Copyright © 2017 Daniel. All rights reserved.
//

import UIKit
import PKHUD
import MGSwipeTableCell

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblStories: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var webToOpen : String = ""
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        HUD.show(.progress)
        
        if Utils.isConnectedToNetwork(){
            Webservice.getStories{ (result: Any?) in
                if let storiesResult = result as? WebserviceJSON{
                    
                    for story in storiesResult.hits{
                        
                        if !self.appDelegate.deletedItems.contains(story.story_id){
                            self.appDelegate.stories.append(story)
                        }
                    }
                    
                    self.tblStories.reloadData()
                    HUD.hide()
                }else{
                    HUD.hide()
                    let alert = Utils.makeSimpleAlert(title: "Problemas al traer datos", subtitle: "Problemas de comunicación remoto")
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            HUD.hide()
            let alert = Utils.makeSimpleAlert(title: "Problemas al traer datos", subtitle: "No hay conexión a Internet")
            
            self.present(alert, animated: true, completion: nil)
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(HomeController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.tblStories.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //reload data
    func refresh(_ sender: Any) {
        
        HUD.show(.progress)
        
        if Utils.isConnectedToNetwork(){
            Webservice.getStories{ (result: Any?) in
                if let storiesResult = result as? WebserviceJSON{
                    
                    self.appDelegate.stories = []
                    
                    for story in storiesResult.hits{
                        
                        if !self.appDelegate.deletedItems.contains(story.story_id){
                            self.appDelegate.stories.append(story)
                        }
                    }
                    
                    self.tblStories.reloadData()
                    self.refreshControl.endRefreshing()
                    HUD.hide()
                }else{
                    HUD.hide()
                    self.refreshControl.endRefreshing()
                    let alert = Utils.makeSimpleAlert(title: "Problemas al traer datos", subtitle: "Problemas de comunicación remoto")
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }else{
            HUD.hide()
            self.refreshControl.endRefreshing()
            //let alert = Utils.makeSimpleAlert(title: "Problemas al traer datos", subtitle: "No hay conexión a Internet")
            
            //self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : StoriesCell = tableView.dequeueReusableCell(withIdentifier: "story", for: indexPath) as! StoriesCell
        
        let story = self.appDelegate.stories[indexPath.row]
        
        if story.title != ""{
            cell.lblTitle.text = story.title
        }else if story.story_title != ""{
            cell.lblTitle.text = story.story_title
        }else{
            cell.lblTitle.text = "No title"
        }
        
        let storyDate : Date = Utils.dateFromString(dateToFormat: story.created_at)
        
        if NSCalendar.current.isDateInToday(storyDate){
            let now = Date()
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.hour, .minute], from: storyDate, to: now)
            
            if components.hour! < 1{
                let minutes : String = components.minute!.description
                cell.lblAuthor.text = story.author + " - " + minutes + "m"
            }else{
                let hours : String = components.hour!.description
                cell.lblAuthor.text = story.author + " - " + hours + "h"
            }
        }else if NSCalendar.current.isDateInYesterday(storyDate){
            cell.lblAuthor.text = story.author + " - Yesterday"
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from:storyDate)
            
            cell.lblAuthor.text = story.author + " - \(dateString)"
        }
        
        //configure swipe actions
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: .red) {
            (sender: MGSwipeTableCell!) -> Bool in
            self.appDelegate.deletedItems.append(story.story_id)
            self.appDelegate.stories.remove(at: indexPath.row)
            self.tblStories.deleteRows(at: [indexPath], with: .fade)
            return true}]
        
        cell.leftSwipeSettings.transition = .rotate3D
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = self.appDelegate.stories[indexPath.row]
        
        if story.url != ""{
            self.webToOpen = story.url
            self.performSegue(withIdentifier: "showWeb", sender: self)
        }else if story.story_url != ""{
            self.webToOpen = story.story_url
            self.performSegue(withIdentifier: "showWeb", sender: self)
        }else{
            let alert = Utils.makeSimpleAlert(title: "Ups!!", subtitle: "No se puede abrir articulo, no posee url")
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showWeb"{
            if let destinationVC = segue.destination as? WebViewController {
                destinationVC.urlToOpen = self.webToOpen
            }
        }
    }

}

