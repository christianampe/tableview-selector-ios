//
//  SubjectsViewController.swift
//  TutorStoryboard
//
//  Created by Ampe on 1/11/17.
//  Copyright © 2017 Ampe. All rights reserved.
//

import UIKit
import Parse

class SubjectsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    var searchActive: Bool = false
    
    var data: [PFObject] = []
    var subjects: [String] = []
    
    var filtered: [String] = []
    var selected: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        loadSubjects()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadSubjects() {
        let query = PFQuery(className: "Subjects")
        
        query.findObjectsInBackground { (objects:[PFObject]?, error: Error?) -> Void in
            
            self.data = objects!
            
            for object in objects! {
                self.subjects.append(object.object(forKey: "name") as! String)
                self.filtered.append(object.object(forKey: "name") as! String)
            }
            self.tableView.reloadData()
        }
        
    }
    
    func configureCheckmarkForCell(cell: SubjectCell, object: String) {
        let label: UILabel = cell.selectedLabel
        if (selected.contains(object)) {
            selectedLabel.text = selected.joined(separator: ", ")
            label.text = "√"
            label.backgroundColor = UIColor.orange
            label.layer.borderWidth = 0
        }
        
        else {
            selectedLabel.text = selected.joined(separator: ", ")
            label.text = ""
            label.backgroundColor = UIColor.clear
            label.layer.borderWidth = 1
        }
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "tobasicinfo", sender: nil)
    }
    
}

extension SubjectsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectcell", for: indexPath) as! SubjectCell
        let string = filtered[indexPath.row]
        cell.subjectLabel!.text = string
        configureCheckmarkForCell(cell: cell, object: string)
        return cell
    }
    
}

extension SubjectsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SubjectCell
        let label: UILabel = cell.selectedLabel
        let string = filtered[indexPath.row]
        
        selected.append(string)
        selectedLabel.text = selected.joined(separator: ", ")
        
        label.text = "√"
        label.backgroundColor = UIColor.orange
        label.layer.borderWidth = 0

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SubjectCell
        let label: UILabel = cell.selectedLabel
        
        let string = filtered[indexPath.row]
        
        selected = selected.filter{$0 != string}
        label.text = ""
        label.backgroundColor = UIColor.clear
        label.layer.borderWidth = 1
        
        selectedLabel.text = selected.joined(separator: ", ")
        
    }
    
}

extension SubjectsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = searchText.isEmpty ? subjects : subjects.filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
}

class SubjectCell: UITableViewCell {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var selectedLabel: UILabel!
    
}
