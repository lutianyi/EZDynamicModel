//
//  EZViewController.m
//  EZDynamicModel
//
//  Created by Ezer on 06/01/2017.
//  Copyright (c) 2017 Ezer. All rights reserved.
//

#import "EZViewController.h"
#import "EZPerson.h"

@interface EZViewController ()

@end

@implementation EZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray * dataList = @[@{@"name"  : @"Tony",
                             @"age"   : @25,
                             @"hobby" : @[@"eat", @"drink"]},
                           @{@"name"  : @"Jack",
                             @"age"   : @28,
                             @"hobby" : @[@"sing", @"dance"]},
                           @{@"name"  : @"Ezer",
                             @"age"   : @26,
                             @"hobby" : @[@"play", @"movie"]}];
    
    // NSArray * person = [EZPerson modelWithArray:dataList];
    
    EZPerson * person = [EZPerson modelWithDictionary:dataList[0]];
    
    NSLog(@"%@", person);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
