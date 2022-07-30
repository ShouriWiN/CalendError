//
//  ViewController.swift
//  CalendError
//
//  Created by JMMac082 on 2022/07/01.
//

import UIKit
import FSCalendar
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var mainViewDate = Date()
    
    let realm = try! Realm()
    var itemLists: Results<missData>!
    
    var hantei = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲートの設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        calendar.layer.cornerRadius = 10
        
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.layer.cornerRadius = 10
        
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.contentHorizontalAlignment = .fill
        addButton.contentVerticalAlignment = .fill
        self.addButton.tintColor = .systemYellow
        //addButton.setTitle("", for: .normal)
        
        let allData = realm.objects(missData.self)
        print("全てのデータ\(allData)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //この下の7行を追加
        let ud = UserDefaults.standard
        let firstLunchKey = "firstLunch"
        if ud.bool(forKey: firstLunchKey) {
            ud.set(false, forKey: firstLunchKey)
            ud.synchronize()
            let realm = try! Realm()
            let missTable = missData()
            
            missTable.dateValue = 20220715
            missTable.start_time = "12:00"
            missTable.end_time = "13:00"
            missTable.tag = "事故"
            missTable.location = "愛知工科大学"
            missTable.miss = "転ぶ（これはサンプルです）"
            
            try! realm.write {
                realm.add(missTable)
            }
        }
        print("viewDidAppear")
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(hantei == 0){
            let dt = Date()
            getModel(dates: dt)
            hantei = 1
        }
        return itemLists.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        //print(itemLists[indexPath.row])
        let itemList = itemLists[indexPath.row]
        
        cell.timeLabel.text = itemList.start_time
        cell.nameLabel.text = itemList.miss
        cell.locationLabel.text = itemList.location
        if (itemList.tag == "人間関係") {
            cell.img.image = UIImage(systemName: "person.2.circle")
        }else if (itemList.tag == "健康"){
            cell.img.image = UIImage(systemName: "cross.circle")
        }else if (itemList.tag == "食事"){
            cell.img.image = UIImage(systemName: "fork.knife.circle")
        }else if (itemList.tag == "仕事"){
            cell.img.image = UIImage(systemName: "building.2.crop.circle")
        }else if (itemList.tag == "金銭関係"){
            cell.img.image = UIImage(systemName: "yensign.circle")
        }else if (itemList.tag == "勉強"){
            cell.img.image = UIImage(systemName: "pencil.circle")
        }else if (itemList.tag == "心"){
            cell.img.image = UIImage(systemName: "heart.circle")
        }else if (itemList.tag == "事故"){
            cell.img.image = UIImage(systemName: "exclamationmark.circle")
        }else{
            cell.img.image = UIImage(systemName: "questionmark.circle")
        }
        
        return cell
    }

    
    // addButton
    var startingFrame : CGRect!
    var endingFrame : CGRect!
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) && self.addButton.isHidden {
            self.addButton.isHidden = false
            self.addButton.frame = startingFrame
            UIView.animate(withDuration: 1.0) {
                self.addButton.frame = self.endingFrame
            }
        }
    }
    
    func configureSizes() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        startingFrame = CGRect(x: 0, y: screenHeight+100, width: screenWidth, height: 100)
        endingFrame = CGRect(x: 0, y: screenHeight-100, width: screenWidth, height: 100)
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let nc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        let followingVC = nc.viewControllers[0] as! AddViewController
        followingVC.nextViewDate = ViewController.stringFromDate(date: mainViewDate, format: "yyyyMMdd")  //ここで値渡し
        self.present(nc, animated: true, completion: nil)  //画面遷移
        
    }
    
    
    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func getModel(dates: Date){
        let strDate = ViewController.stringFromDate(date: dates, format: "yyyyMMdd")
        print(Int(strDate) ?? 0)
        
        let intDate = Int(strDate) ?? 0
        
        itemLists = realm.objects(missData.self).filter("dateValue == %d" ,intDate)
        print(itemLists)
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        mainViewDate = date
        getModel(dates: date)
        tableView.reloadData()
    }
    
}

//tableCellスワイプアクション
extension ViewController {
    // スワイプした時に表示するアクションの定義
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedData = itemLists[indexPath.row].miss
        
        // 削除処理
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            //削除処理を記述
            print("Deleteがタップされた")
            let results = self.realm.objects(missData.self).filter("miss == %s" ,selectedData)
            do {
                try self.realm.write {
                    self.realm.delete(results[indexPath.row])
                    self.getModel(dates: self.mainViewDate)
                    //tableView.reloadData()
                }
            } catch {
                print("delete data error.")
            }
            // 実行結果に関わらず記述
            completionHandler(true)
        }
        
        // 定義したアクションをセット
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
