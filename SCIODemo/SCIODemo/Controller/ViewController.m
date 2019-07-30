//
//  ViewController.m
//  ZYDataCollectionDemo
//
//  Created by Daniel Chuang on 2019/3/4.
//  Copyright © 2019年 Daniel Chuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (nonatomic,copy) NSString *string;
@property (nonatomic,copy) NSDictionary *dictionary;
@end

@implementation ViewController {
    NSString *testString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _actionLabel.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionLabelClick:)];
    [_actionLabel addGestureRecognizer:tap];
    
    NSMutableArray *items = self.navigationItem.rightBarButtonItems.mutableCopy;
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"Title-Item" style:UIBarButtonItemStylePlain target:self action:@selector(customItemClick)];
    [items addObject:titleItem];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(customItemClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"custom" forState:UIControlStateNormal];
    UIBarButtonItem *cusItem1 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [items addObject:cusItem1];
    [self.navigationItem setRightBarButtonItems:items animated:true];
    
    UIView *cusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    cusView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    cusView.userInteractionEnabled = true;
    UITapGestureRecognizer *viewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customItemClick)];
    [cusView addGestureRecognizer:viewtap];
    UIBarButtonItem *viewItem = [[UIBarButtonItem alloc] initWithCustomView:cusView];
    self.navigationItem.leftBarButtonItem = viewItem;
    
    _string = @"天道好轮回, 苍天绕过谁";
    _dictionary = @{@"key":@"天道好轮回, 苍天绕过谁"};
    testString = @"娃哈哈";
    
    
    NSString *str0 = [self valueForKeyPath:@"string"];
    NSString *str1 = [self valueForKeyPath:@"actionLabel.text"];
    NSString *str2 = [self valueForKeyPath:@"dictionary.key"];
    NSString *str3 = [self valueForKeyPath:@"testString"];
    
    NSLog(@"%@\n%@\n%@\n%@", str0, str1, str2, str3);
}

- (void)customItemClick {
    NSLog(@"Custom");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)actionLabelClick:(UIGestureRecognizer *)ges {
    NSLog(@"label点击");
}

- (IBAction)btnClick:(id)sender {
    NSLog(@"点击");
}
- (IBAction)editingDidBegin:(id)sender {
    NSLog(@"开始点击");
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

@end
