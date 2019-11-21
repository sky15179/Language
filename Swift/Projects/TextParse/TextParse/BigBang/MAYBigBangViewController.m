//
//  MAYBigBangViewController.m
//  MeituanMovie
//
//  Created by 王智刚 on 2018/11/1.
//  Copyright © 2018 sankuai. All rights reserved.
//

#import "MAYBigBangViewController.h"
#import "MAYNewsDetailViewController.h"

@interface MAYBigBangViewController ()

@end

@implementation MAYBigBangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 200, 100);
    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.numberOfLines = 0;
    [btn setTitle:@"资讯,选中文本,选择bigbang" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view from its nib.
}

- (void)push {
    MAYNewsDetailViewController *newsDetailVC = [[MAYNewsDetailViewController alloc] initWithNewsId:49934];
    [self.navigationController pushViewController:newsDetailVC animated:YES];
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
