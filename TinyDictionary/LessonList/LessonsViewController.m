//
//  LessonsViewController.m
//  TinyDictionary
//
//  Created by wyj on 2018/6/8.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "LessonsViewController.h"
#import "TinyDictionary-Swift.h"

@interface LessonsViewController ()
@property (nonatomic,strong) LessonViewModel *lessonVM;
@property (nonatomic,strong) TableViewModel *tableVM;
@end

@implementation LessonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lessonVM = [[LessonViewModel alloc] init];
    self.tableVM = [[TableViewModel alloc] initWithIdentifier:@"LessonCell" viewModel:self.lessonVM tableview:self.mainTableview];
    
    self.mainTableview.delegate = self.tableVM;
    self.mainTableview.dataSource = self.tableVM;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
