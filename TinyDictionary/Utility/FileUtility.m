//
//  FileUtility.m
//  TinyDictionary
//
//  Created by wyj on 2018/6/7.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "FileUtility.h"
#import "Vocabulary.h"

#define GERMANKEY @"german"
#define ENGLISHKEY @"english"
#define COUNTKEY @"count"

@interface FileUtility ()
@property (nonatomic,strong) NSMutableArray *wordsInfoArray;
@end

@implementation FileUtility

+ (FileUtility *)shareInstance{
    static FileUtility * s_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (s_instance == nil) {
            s_instance = [[FileUtility alloc] init];
            [s_instance createFirshLesson];
        }
        
    });

    return s_instance;
}

-(void)createFirshLesson
{
    self.wordsInfoArray = [[NSMutableArray alloc] init];
    
    [self.wordsInfoArray addObject:[FileUtility createWordItem:@"Tisch" english:@"table" count:@"0"]];
    [self.wordsInfoArray addObject:[FileUtility createWordItem:@"Wetter" english:@"weather" count:@"0"]];
    [self.wordsInfoArray addObject:[FileUtility createWordItem:@"Fahrrad" english:@"bicycle" count:@"0"]];
    
    [self writeDateToFile:self.wordsInfoArray];
}

-(void)updateDateToFile:(NSMutableArray*)dataSource
{
    if (self.wordsInfoArray) {
        [self.wordsInfoArray removeAllObjects];
    } else {
        self.wordsInfoArray = [[NSMutableArray alloc] init];
    }
    
    for (Vocabulary *vItem in dataSource) {
        [self.wordsInfoArray addObject:[FileUtility createWordItem:vItem.german english:vItem.english count:vItem.count]];
    }
    [self writeDateToFile:self.wordsInfoArray];
}

+(NSMutableDictionary*)createWordItem:(NSString*)sGerman english:(NSString*)sEnglish count:(NSString*)sCount
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:sGerman forKey:GERMANKEY];
    [dict setValue:sEnglish forKey:ENGLISHKEY];
    [dict setValue:sCount forKey:COUNTKEY];
    return dict;
}

-(void)writeDateToFile:(NSMutableArray*)dataArray
{
    if (![FileUtility isFileExist]) {
        [[NSFileManager defaultManager] createFileAtPath: [FileUtility dataFilePath] contents:nil attributes:nil];
        NSLog(@"Create File");
    }
    
    NSMutableString *csvString = [[NSMutableString alloc]initWithCapacity:0];
    [csvString appendString:@"German,English,Count\n"];
    
    for (NSMutableDictionary *dic in dataArray) {
        NSString *sGerman = [dic objectForKey:GERMANKEY];
        NSString *sEnglish = [dic objectForKey:ENGLISHKEY];
        NSString *sCount = [dic objectForKey:COUNTKEY];
        NSString *sRow = [NSString stringWithFormat:@"%@,%@,%@\n",sGerman,sEnglish,sCount];
        [csvString appendString:sRow];
    }
    
    NSError *error = nil;
    [csvString writeToFile:[FileUtility dataFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error != nil) {
        NSLog(@"Fail");
    }
}

+(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"myfile.csv"];
}

+(BOOL)isFileExist{
    BOOL bExist = [[NSFileManager defaultManager] fileExistsAtPath:[FileUtility dataFilePath]];
    return bExist;
}

+(NSMutableArray*)readDateFromFile
{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSData *data = [NSData dataWithContentsOfFile:[FileUtility dataFilePath]];
    NSString *strInfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray* allLinedStrings =[strInfo componentsSeparatedByString:@"\n"];
    for (int i = 1;i < allLinedStrings.count; i++) {
        NSString *sItem = [allLinedStrings objectAtIndex:i];
        
        //Get words
        NSArray *itemArray = [sItem componentsSeparatedByString:@","];
        
        if (itemArray.count == 3) {
            NSMutableDictionary *itemDic = [FileUtility createWordItem:itemArray[0] english:itemArray[1] count:itemArray[2]];
            [dataArray addObject:itemDic];
        }
    }
    
    return dataArray;
}

+(NSMutableArray*)getEntityArrayFromDatas:(NSMutableArray*)datas
{
    NSMutableArray *vocabularyArray = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dic in datas) {
        Vocabulary *vItem = [[Vocabulary alloc] init];
        for (NSString *sKey in dic.allKeys) {
            [vItem setValue:[dic objectForKey:sKey] forKey:sKey];
        }
        [vocabularyArray addObject:vItem];
    }
    return vocabularyArray;
}
 

@end
