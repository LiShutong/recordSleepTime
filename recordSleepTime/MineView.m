//
//  mineView.m
//  recordSleepTime
//
//  Created by 李书通 on 2017/11/30.
//  Copyright © 2017年 李书通. All rights reserved.
//

#import "MineView.h"
@interface MineView(){
    UITextField *nameDetail;
    UITextField *sexDetail;
    UITextField *ageDetail;
    UIButton *savebtn;
    NSMutableDictionary *dictionary;
}

@end

@implementation MineView

 //初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 100, 30)];
        nameLable.text = @"Name:";
        [nameLable setTextColor: [UIColor whiteColor]];
        UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 130, 100, 30)];
        sexLabel.text = @"Sex:";
        [sexLabel setTextColor: [UIColor whiteColor]];
        UILabel *AgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 160, 100, 30)];
        AgeLabel.text = @"Age:";
        [AgeLabel setTextColor: [UIColor whiteColor]];
        [self addSubview:nameLable];
        [self addSubview:sexLabel];
        [self addSubview:AgeLabel];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 50, 150, 30)];
        [btn setTitle:@"Change Data" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:254/255.0 green:236/255.0 blue:168/255.0 alpha:1];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        savebtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 200, 100, 30)];
        [savebtn setTitle:@"Save" forState:UIControlStateNormal];
        savebtn.backgroundColor = [UIColor colorWithRed:254/255.0 green:236/255.0 blue:168/255.0 alpha:1];
        [savebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        savebtn.hidden = YES;
        [savebtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:savebtn];

        nameDetail = [[UITextField alloc] initWithFrame:CGRectMake(150, 100, 100, 30)];
        nameDetail.userInteractionEnabled = NO;
        sexDetail = [[UITextField alloc] initWithFrame:CGRectMake(150, 130, 100, 30)];
        sexDetail.userInteractionEnabled = NO;
        ageDetail = [[UITextField alloc] initWithFrame:CGRectMake(150, 160, 100, 30)];
        ageDetail.userInteractionEnabled = NO;
        [nameDetail setTextColor: [UIColor whiteColor]];
        [sexDetail setTextColor: [UIColor whiteColor]];
        [ageDetail setTextColor: [UIColor whiteColor]];
        [self reloadViewData];
        [self addSubview:nameDetail];
        [self addSubview:sexDetail];
        [self addSubview:ageDetail];
        //键盘类型
        ageDetail.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:ageDetail];
    }
    return self;
}
//需要刷新数据了调用
- (void)reloadViewData {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"data.plist"];
    if ([NSArray arrayWithContentsOfFile:path].count > 1) {
        dictionary = [[NSArray arrayWithContentsOfFile:path] lastObject];
    } else {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    nameDetail.text = dictionary[@"name"];
    sexDetail.text = dictionary[@"sex"];
    ageDetail.text = dictionary[@"age"];
}
-(void)btnClick {
    NSLog(@"lst");
    savebtn.hidden = NO;
    nameDetail.userInteractionEnabled = YES;
    sexDetail.userInteractionEnabled = YES;
    ageDetail.userInteractionEnabled = YES;
}
- (void)saveBtnClick {
    savebtn.hidden = YES;
    nameDetail.userInteractionEnabled = NO;
    sexDetail.userInteractionEnabled = NO;
    ageDetail.userInteractionEnabled = NO;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"data.plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];
    dictionary = [[NSMutableDictionary alloc] initWithDictionary:[array lastObject]];
    dictionary[@"name"] = nameDetail.text;
    dictionary[@"sex"] = sexDetail.text;
    dictionary[@"age"] = ageDetail.text;
    [array replaceObjectAtIndex:1 withObject:dictionary];
    [array writeToFile:path atomically:YES];
}
@end
