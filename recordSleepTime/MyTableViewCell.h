//
//  myTableViewCell.h
//  recordSleepTime
//
//  Created by 李书通 on 2017/11/30.
//  Copyright © 2017年 李书通. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *weakUpLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@end
