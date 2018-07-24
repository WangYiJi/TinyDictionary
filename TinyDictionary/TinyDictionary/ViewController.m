//
//  ViewController.m
//  TinyDictionary
//
//  Created by wyj on 2018/6/7.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "ViewController.h"
#import "FileUtility.h"
#import "Vocabulary.h"
#import "LessonsViewController.h"

typedef enum: NSUInteger {
    Continue  = 0,
    Next,
    Restart
} TestType;

typedef void (^courseFinish)(void);
typedef void (^courseContinue)(void);

@interface ViewController ()
@property (nonatomic,strong) NSMutableArray *vocabularyArray;
@property (nonatomic,strong) Vocabulary *currentVocabulary;
@property (nonatomic,assign) NSInteger iCurrentIndex;
@property (nonatomic,assign) TestType currentType;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.title = @"MyFirstLesson";
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(didPressedRight)];
    self.navigationItem.rightBarButtonItem = rightBar;

    [self createBaseData];
    
    if (self.currentType != Restart) {
        [self.txtInput becomeFirstResponder];
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)didPressedRight {
    LessonsViewController *lessonVC = [[LessonsViewController alloc] initWithNibName:@"LessonsViewController" bundle:nil];
    [self.navigationController pushViewController:lessonVC animated:YES];
}

-(void)createBaseData {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (![FileUtility isFileExist]) {
            [[FileUtility shareInstance] createFirshLesson];
        }
        
        NSMutableArray *sourceArray = [FileUtility readDateFromFile];
        [self createEntitysFromStore:sourceArray];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf displayDataToView];
        });
    });
}

-(void)createEntitysFromStore:(NSMutableArray*)sources
{
    if (self.vocabularyArray) {
        [self.vocabularyArray removeAllObjects];
        self.vocabularyArray = nil;
    }
    
    self.vocabularyArray = [[NSMutableArray alloc] initWithArray:[FileUtility getEntityArrayFromDatas:sources]];

}

-(void)displayDataToView
{
    if (self.vocabularyArray.count > 0) {
        NSInteger iRandomIndex = [self getRandomIndex];
        //Each load next vocabulary will occur two condition
        if (iRandomIndex == -1) {
            //All vocabularys are finish
            self.currentType = Restart;
            
        } else {
            Vocabulary *vItem = [self.vocabularyArray objectAtIndex:iRandomIndex];
            self.currentVocabulary = vItem;
            self.iCurrentIndex = iRandomIndex;
            if (self.currentVocabulary) {
                self.lblGermanValue.text = [NSString stringWithFormat:@"%@",self.currentVocabulary.german];
            }
            self.currentType = Continue;
        }
    }
}

//change UI
-(void)setCurrentType:(TestType)type
{
    if (type != Restart) {
        self.lblGermanTitle.hidden = NO;
        self.lblGermanValue.hidden = NO;
        self.lblEnglishTitle.hidden = NO;
        self.lblEnglishTitle.text = @"English";
        self.txtInput.hidden = NO;
        self.lblResultCount.hidden = YES;
        [self.txtInput becomeFirstResponder];
    }
    
    switch (type) {
        case Continue:
            self.txtInput.text = @"";
            self.resultImage.hidden = YES;
            self.lblCorrectVocabulary.hidden = YES;
            [self.btnAction setTitle:@"Continue" forState:UIControlStateNormal];
            break;
        case Next:
        {
            self.resultImage.hidden = NO;
            //Cut white space
            
            NSString *stxt = [self.txtInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *sEnglish = [self.currentVocabulary.english stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([stxt isEqualToString:sEnglish]) {
                self.lblCorrectVocabulary.hidden = YES;
                self.resultImage.image = [UIImage imageNamed:@"right"];
            } else {
                self.lblCorrectVocabulary.hidden = NO;
                self.lblCorrectVocabulary.text = [NSString stringWithFormat:@"Correct:%@",self.currentVocabulary.english];
                self.resultImage.image = [UIImage imageNamed:@"wrong"];
            }
            
            [self.btnAction setTitle:@"Next" forState:UIControlStateNormal];
        }

            break;
        case Restart:
            self.lblGermanTitle.hidden = YES;
            self.lblGermanValue.hidden = YES;
            self.lblEnglishTitle.hidden = NO;
            self.lblEnglishTitle.text = @"You successfully finished the lesson!";
            
            self.txtInput.hidden = YES;
            self.resultImage.hidden = YES;
            
            self.lblCorrectVocabulary.hidden = YES;
            self.lblResultCount.hidden = NO;
            self.lblResultCount.text = [NSString stringWithFormat:@""];
            [self.btnAction setTitle:@"Restart" forState:UIControlStateNormal];
            
            [self.txtInput resignFirstResponder];
            break;
            
        default:
            break;
    }
    _currentType = type;
}

- (IBAction)didPressedAction:(id)sender {
    switch (self.currentType) {
        case Continue:
            if (self.currentVocabulary) {
                //Cut white space
                NSString *stxt = [self.txtInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString *sEnglish = [self.currentVocabulary.english stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                if ([stxt isEqualToString:sEnglish]) {
                    NSInteger iNewNumber = [self.currentVocabulary.count integerValue]+1;
                    if ([self.currentVocabulary.count isEqualToString:@"-1"]) {
                        iNewNumber ++;
                    }
                    self.currentVocabulary.count = [NSString stringWithFormat:@"%ld",iNewNumber];
                } else {
                    self.currentVocabulary.count = @"-1";
                }
                self.vocabularyArray[self.iCurrentIndex] = self.currentVocabulary;
                
                self.currentType = Next;
            }
            break;
        case Next:
            //Refresh another vocabulary to view
            [self displayDataToView];
            break;
        case Restart:
            [self restartLesson];
            [self displayDataToView];
            break;
            
        default:
            break;
    }
    //Store Date in each action
    [self storeDateToFile];
}

-(void)restartLesson
{
    for (Vocabulary *vItem in self.vocabularyArray) {
        vItem.count = @"0";
    }
}

- (IBAction)didPressedDone:(id)sende
{
    [self.txtInput resignFirstResponder];
}

-(NSInteger)getRandomIndex {
    NSMutableArray *tempIndexs = [[NSMutableArray alloc] init];
    //avoid endless loop
    while (tempIndexs.count < self.vocabularyArray.count) {
        NSInteger iTempRIndex = arc4random() % self.vocabularyArray.count;
        Vocabulary *tempVocabular = [self.vocabularyArray objectAtIndex:iTempRIndex];
        if ([tempVocabular.count integerValue] >= 4) {
            //
            NSString *sIndexValue = [NSString stringWithFormat:@"%ld",iTempRIndex];
            if (![tempIndexs containsObject:sIndexValue]) {
                [tempIndexs addObject:sIndexValue];
            }
            continue;
        } else {
            NSLog(@"Got random index %ld",iTempRIndex);
            return iTempRIndex;
            break;
        }
    }
    NSLog(@"tempRandomIndex %@",tempIndexs);
    return -1;
}

-(void)storeDateToFile
{
    [[FileUtility shareInstance] updateDateToFile:self.vocabularyArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
