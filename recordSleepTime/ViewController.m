//
//  ViewController.m
//  recordSleepTime
//
//  Created by 李书通 on 2017/11/29.
//  Copyright © 2017年 李书通. All rights reserved.
//

#import "ViewController.h"
#import "SleepDataModel.h"
#import "MyTableViewCell.h"
#import "MineView.h"

@interface ViewController (){
    UIView *sleepResultView;
    MineView *myView;
    NSString *starTime;
}
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *sleepTime;
@property (nonatomic, assign) BOOL isSleep;
@property (strong, nonatomic) NSTimer *time;
@property (nonatomic, assign) int count;
@property (nonatomic, strong) NSMutableArray *sleepData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //搭建页面
    [self createView];
    //获取数据
    [self loadData];
    
    _startBtn.layer.cornerRadius = _startBtn.frame.size.width/2;
    _startBtn.clipsToBounds= YES;
    _startBtn.layer.borderWidth = 1;
    _startBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _startBtn.titleLabel.lineBreakMode = 0;
    _startBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}
-  (void) createView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"myTableViewCell" bundle:nil] forCellReuseIdentifier:@"tableViewCell"];//cell的注册 用的时候就可以直接用了
}
//获取数据接口 需要数据刷新的时候调用  就是在展示tableView的时候
- (void)loadData {
    //取数据
    //路径-沙河路经
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"data.plist"];
    //文件管理器 文件不存在就创建
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL bRet = [fileManager fileExistsAtPath:path];
    if (!bRet) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"jack",@"name",@"boy",@"sex",@"18",@"age",nil];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"11-30 08:08 PM",@"startTime",@"11-30 08:10 PM",@"endTime",@"00:02:01",@"hour",@"C",@"quantity",nil];
        NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"11-31 08:08 PM",@"startTime",@"11-31 08:10 PM",@"endTime",@"00:02:01",@"hour",@"C",@"quantity",nil];
        [array addObject:dic1];
        [array addObject:dic2];
        NSArray *dataArr = @[array,dic];
        [dataArr writeToFile:path atomically:YES];
    }
    NSArray *dataArr =[NSMutableArray arrayWithContentsOfFile:path];
    NSMutableArray *data ;
    if (dataArr.count >1) {
        data = [dataArr firstObject];
    } else {
        data = [[NSMutableArray alloc] init];

    }
    _sleepData = [SleepDataModel modelArrWithDataArr:data];
    [_tableView reloadData];

}
- (IBAction)startBtnClick:(id)sender {
    if (!_isSleep) {
        _isSleep = true;
        [_startBtn setTitle:@"Weak Up" forState:UIControlStateNormal];
        if (self.time) {
            [self.time invalidate];
            self.time = nil;
        }
        self.time = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(repeatShowTime:)
                                                    userInfo:@"admin"
                                                     repeats:YES];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd hh:mm a"];
        starTime = [dateFormatter stringFromDate:date];
    }else {
        _isSleep = false;
        [_startBtn setTitle:@"Start" forState:UIControlStateNormal];
        if (self.time) {
            [self.time invalidate];
            self.time = nil;
        }
        [self.time setFireDate:[NSDate distantFuture]];
        [self savaSleepData];
        [self addSleepResultView];
        self.count = 0;
        self.sleepTime.text = @"Time";
    }
}
- (IBAction)sleepingBtn:(id)sender {
    [sleepResultView removeFromSuperview];
    [myView removeFromSuperview];
    [_tableView removeFromSuperview];
    _startBtn.hidden = NO;
    _sleepTime.hidden = NO;
}
- (IBAction)recordView:(id)sender {
    _startBtn.hidden = YES;
    _sleepTime.hidden = YES;
    [myView removeFromSuperview];
    //刷新数据
    [self loadData];
    //添加页面
    [self.view addSubview:_tableView ];
}
- (IBAction)mineBtn:(id)sender {
    [_tableView removeFromSuperview];
    [self addMineView];
}


- (void)repeatShowTime:(NSTimer *)tempTimer {
    self.count++;
    self.sleepTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",self.count / 60 * 60,self.count/60,self.count%60];
}

- (void)savaSleepData {
    // NSDocumentDirectory 要查找的文件
    // NSUserDomainMask 代表从用户文件夹下找
    // 在iOS中，只有一个目录跟传入的参数匹配，所以这个集合里面只有一个元素
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"data.plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];

    NSMutableArray *data ;
    if (array.count > 1) {
       data = [array firstObject];
    } else {
        data = [[NSMutableArray alloc] init];
        array = [[NSMutableArray alloc] initWithObjects:data,@[], nil];
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd hh:mm a"];
    NSString *endTime = [dateFormatter stringFromDate:date];
    NSString *hour = [NSString stringWithFormat:@"%02d:%02d:%02d",self.count / 60 * 60,self.count/60,self.count%60];;
    NSString *quantity = [self checkSleepQuantity];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:starTime,@"startTime",endTime,@"endTime",hour,@"hour",quantity,@"quantity",nil];
    [data addObject:dic];
    [array writeToFile:path atomically:YES];
}



- (void)addSleepResultView {
    sleepResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)];
    _startBtn.hidden = YES;
    _sleepTime.hidden = YES;
    [self addReturnBtn];
    [self addFourLabel];
    [self.view addSubview: sleepResultView];
    CATransition *animation = [CATransition animation];
    animation.duration = 1.25f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:animation forKey:@"animation"];
}

//sleepResultView页面的返回按钮
- (void)addReturnBtn {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 80, 30)];
    [btn addTarget:self action:@selector(returnSleepingView) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Back" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:254/255.0 green:236/255.0 blue:168/255.0 alpha:1];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sleepResultView addSubview:btn];
}
- (void)returnSleepingView {
    _startBtn.hidden = NO;
    _sleepTime.hidden = NO;
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [sleepResultView.layer addAnimation:animation forKey:@"animation"];
    [self performSelector:@selector(delayMethod) withObject:self afterDelay:1.0f];
}
- (void)delayMethod {
    [sleepResultView removeFromSuperview];
}
//sleepResultView页面的显示标签
- (void)addFourLabel {
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, 200, 30)];
    label1.text = @"Your sleeping time is:";
    label1.textColor = [UIColor whiteColor];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, 200, 30)];
    label2.text = @"Yout sleeping quantity is:";
    label2.textColor = [UIColor whiteColor];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(250, 100, 100, 30)];
    label3.text =[NSString stringWithFormat:@"%02d:%02d:%02d",self.count / 60 * 60,self.count/60,self.count%60];
    label3.textColor = [UIColor whiteColor];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(250, 120, 200, 30)];
    label4.text = [self checkSleepQuantity];
    label4.textColor = [UIColor whiteColor];
    [sleepResultView addSubview:label1];
    [sleepResultView addSubview:label2];
    [sleepResultView addSubview:label3];
    [sleepResultView addSubview:label4];
}

- (NSString *)checkSleepQuantity{
    NSString *str = [[NSString alloc] init];
    double hour = self.count / 60 *60;
    if (hour >= 10) {
        str = @"A";
    } else if (hour >= 8 && hour < 10){
        str = @"B";
    } else {
        str = @"C";
    }
    return str;
}

- (void) addMineView {
    _startBtn.hidden = YES;
    _sleepTime.hidden = YES;
    [sleepResultView removeFromSuperview];
    [myView removeFromSuperview];
    [_tableView removeFromSuperview];
    myView = [[MineView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)];
    [self.view addSubview:myView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"tableViewCell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    SleepDataModel *model = [_sleepData objectAtIndex:indexPath.row];
    cell.startLabel.text = model.startTime;
    cell.weakUpLabel.text = model.endTime;
    cell.hourLabel.text = model.hour;
    cell.quantityLabel.text = model.quantity;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sleepData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
