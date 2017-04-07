//
//  ViewController.swift
//  taskapp
//
//  Created by 山崎大聖 on 2017/03/27.
//  Copyright © 2017年 山崎大聖. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    
    
    
    let realm = try!Realm()

    var taskArray = try! Realm().objects(Task.self).sorted(byProperty: "date", ascending: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.)
        tabelView.delegate = self
        tabelView.dataSource = self
        SearchBar.delegate = self
        
        //何も入力されていなくてもReturnキーを押せるようにする。
        SearchBar.enablesReturnKeyAutomatically = false
    
    }
    //検索ボタン押下時の呼び出しメソッド
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        SearchBar.endEditing(true)
        
        print(searchText)
        
        let predicate = NSPredicate(format: "category = %@", searchText)
        taskArray = realm.objects(Task.self).filter(predicate)
        tabelView.reloadData()
        
    
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
      let inputViewController:InputViewController = segue.destination as! InputViewController
       
       if segue.identifier == "cellSegue"{
        let indexPath = self.tabelView.indexPathForSelectedRow
        inputViewController.task = taskArray[indexPath!.row]
        }else{
           let task = Task()
           task.date = NSDate()
        
            if taskArray.count != 0 {
                task.id = taskArray.max(ofProperty: "id")!+1
            }
        
            inputViewController.task = task
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabelView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
    
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date as Date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            let task = self.taskArray[indexPath.row]
            
            // ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            try! realm.write{
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            }
            // 未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("---------------/")
                }
            }
        }
    }
    


}

