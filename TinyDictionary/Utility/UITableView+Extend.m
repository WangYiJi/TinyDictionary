//
//  UITableView+Extend.m
//  ToDoList
//
//  Created by Alex on 12/03/2018.
//  Copyright © 2018 company. All rights reserved.
//

#import "UITableView+Extend.h"

@implementation UITableView (Extend)

-(UITableViewCell *)customdq:(NSString *)identifier
{
    UITableViewCell* cell = (UITableViewCell*)[self dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        
        for (id oneObject in nibs)
        {
//            if ([oneObject isKindOfClass:NSClassFromString(identifier)])
//            {
                cell = oneObject;
//            }
        }
    }
    return cell;
}

@end
