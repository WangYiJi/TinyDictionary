//
//  ViewController.h
//  TinyDictionary
//
//  Created by wyj on 2018/6/7.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblGermanTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblGermanValue;

@property (weak, nonatomic) IBOutlet UILabel *lblEnglishTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtInput;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;

@property (weak, nonatomic) IBOutlet UILabel *lblCorrectVocabulary;

@property (weak, nonatomic) IBOutlet UILabel *lblResultCount;

@property (weak, nonatomic) IBOutlet UIButton *btnAction;

- (IBAction)didPressedAction:(id)sender;
- (IBAction)didPressedDone:(id)sender;


@end

