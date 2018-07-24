//
//  LessonViewModel.swift
//  TinyDictionary
//
//  Created by wyj on 2018/6/8.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

class LessonViewModel: NSObject {
    dynamic var lessonArray:NSMutableArray = [];
    
    public func getLessonFromFile () {
        let dataArray:NSMutableArray = FileUtility.readDateFromFile()
        let tempDataArray:NSMutableArray = FileUtility.getEntityArray(fromDatas: dataArray)
        self.lessonArray = NSMutableArray(array: tempDataArray)
    }
    

}
