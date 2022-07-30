//
//  AddViewController.swift
//  CalendError
//
//  Created by JMMac036 on 2022/07/01.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tagPicker: UIPickerView!
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var startText: UITextField!
    @IBOutlet weak var endText: UITextField!
    
    @IBOutlet weak var locateText: UITextField!
    @IBOutlet weak var missText: UITextField!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    
    //UIPickerViewに表示するデータ
    let tagArray: [String] = ["人間関係","健康","食事","仕事","金銭関係","勉強","心","事故"]
    var tag: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate設定
        tagPicker.delegate = self
        tagPicker.dataSource = self
        
        startText.delegate = self
        endText.delegate = self
        locateText.delegate = self
        missText.delegate = self
        
        scrollView.keyboardDismissMode = .interactive
        self.navigationItem.title = nextViewDate
        
        addBarButtonItem.isEnabled = false
    }
    
    var nextViewDate = ""
    var childCallBack: ((String) -> Void)?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear()")
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    //ピッカー
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tagArray.count
    }
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return tagArray[row]
    }
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        tag = tagArray[row]
        tagLabel.text = "タグ：" + tag
    }
    
    
    @IBAction func addBtnTapped(_ sender: Any) {
        createEvent()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //データベースに追加
    func createEvent() {
        
        let realm = try! Realm()
        let missTable = missData()
        
        missTable.dateValue = Int(nextViewDate) ?? 0
        missTable.start_time = startText.text ?? ""
        missTable.end_time = endText.text ?? ""
        if(tag == nil){
            missTable.tag = "タグなし"
        }else{
            missTable.tag = tag ?? ""
        }
        missTable.location = locateText.text ?? ""
        missTable.miss = missText.text ?? ""
        
        try! realm.write {
            realm.add(missTable)
        }
    }
    
    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
}

extension AddViewController {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if(startText.text!.isEmpty || endText.text!.isEmpty || locateText.text!.isEmpty || missText.text!.isEmpty){
            addBarButtonItem.isEnabled = false
        }else{
            addBarButtonItem.isEnabled = true
        }
    }
}
