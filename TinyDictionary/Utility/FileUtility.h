//
//  FileUtility.h
//  TinyDictionary
//
//  Created by wyj on 2018/6/7.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtility : NSObject

+ (FileUtility *)shareInstance;

-(void)createFirshLesson;
-(void)writeDateToFile:(NSMutableArray*)dataArray;
-(void)updateDateToFile:(NSMutableArray*)dataSource;

+(NSMutableDictionary*)createWordItem:(NSString*)sGerman english:(NSString*)sEnglish count:(NSString*)sCount;

+(BOOL)isFileExist;
+(NSString *)dataFilePath;

+(NSMutableArray*)readDateFromFile;
+(NSMutableArray*)getEntityArrayFromDatas:(NSMutableArray*)datas;
@end
