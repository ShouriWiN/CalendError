//
//  SearchViewController.swift
//  CalendError
//
//  Created by JMMac036 on 2022/07/01.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tagPopupBtn: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    
    let realm = try! Realm()
    var searchItemLists: Results<missData>!
    
    var tagSelect: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        setPopupButton()
        
        tagSelect = "人間関係" //ピッカー選択の初期値
        getModel()
        
        tagPopupBtn.layer.cornerRadius = 5.0 //角丸のサイズ
    }
    
    func setPopupButton() {
        let optionClosure = {(action : UIAction) in
            print(action.title)
            self.tagSelect = action.title
            self.getModel()
        }
        
        
        tagPopupBtn.menu = UIMenu(children : [
            UIAction(title : "人間関係", state: .on, handler: optionClosure),
            UIAction(title : "健康", handler: optionClosure),
            UIAction(title : "食事", handler: optionClosure),
            UIAction(title : "仕事", handler: optionClosure),
            UIAction(title : "金銭関係", handler: optionClosure),
            UIAction(title : "勉強", handler: optionClosure),
            UIAction(title : "心", handler: optionClosure),
            UIAction(title : "事故", handler: optionClosure),
            UIAction(title : "タグなし", handler: optionClosure)])
        
        tagPopupBtn.showsMenuAsPrimaryAction = true
        tagPopupBtn.changesSelectionAsPrimaryAction = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItemLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        //print(searchItemLists[indexPath.row])
        let itemList = searchItemLists[indexPath.row]
        cell.tagLabel.text = (String(itemList.dateValue) + "　" +  itemList .start_time + " ~ " + itemList.end_time)
        cell.missLabel.text = itemList.miss
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func initTableView() {
        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        searchTableView.estimatedRowHeight = 150 //初期値
        
        searchTableView.rowHeight = UITableView.automaticDimension
        
    }
    
    func getModel(){
        searchItemLists = realm.objects(missData.self).filter("tag == %s" ,tagSelect ?? "0")
        print(searchItemLists)
        searchTableView.reloadData()
    }
    
}
