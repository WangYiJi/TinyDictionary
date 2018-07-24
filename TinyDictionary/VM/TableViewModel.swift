//
//  TableViewModel.swift
//  TinyDictionary
//
//  Created by wyj on 2018/6/8.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

let DEFINEKEYPATH = "lessonArray"

/*
protocol TableViewModelDelegate : NSObjectProtocol{
    func getTableviewFromVC() -> UITableView
}
 */

protocol TableviewModelDelegate:NSObjectProtocol {
    func getTableviewFromVC() -> UITableView
}

class TableViewModel: NSObject,UITableViewDelegate,UITableViewDataSource {
    
    var tableviewID:String = ""
    var lessonVM:LessonViewModel!
    private var myContext = 0
    weak var tableview:UITableView!
    
    weak var delegate:TableviewModelDelegate?
    
    init(identifier:NSString,viewModel:LessonViewModel,tableview:UITableView) {
        super.init()
        self.lessonVM = viewModel
        self.tableview = tableview
        self.tableviewID = identifier as String
        bindViewModel()
        
        self.lessonVM.getLessonFromFile()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        lessonVM.removeObserver(self, forKeyPath: DEFINEKEYPATH)
    }
    
    func bindViewModel() -> Void {
        lessonVM.addObserver(self, forKeyPath: DEFINEKEYPATH, options: [.new, .old], context: &myContext)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lessonVM.lessonArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let voc:Vocabulary = self.lessonVM.lessonArray.object(at: indexPath.row) as! Vocabulary
        let cell:LessonCell = tableView.customdq(tableviewID) as! LessonCell
        
        cell.lblGerman.text = "German: "+voc.german
        cell.lblEnglish.text = "English: "+voc.english
        return cell
    }
}

extension TableViewModel {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == DEFINEKEYPATH {
            
            //Use Main thread call UI
            DispatchQueue.main.async { [weak self] in
                self?.tableview.reloadData()
            }
        }
    }
}
