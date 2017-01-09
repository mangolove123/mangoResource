//
//  ViewController.m
//  MangoTest
//
//  Created by Mango on 2016/12/24.
//  Copyright © 2016年 Mango. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

#define ENSURE_NOTNULL(v) (v ? v : @"")


@interface ViewController ()

@end

@implementation ViewController

//+ (instancetype)test:(id)v{
//    
//   return [v isKindOfClass:[NSString class]] ? (v ? v : @"") : (v ? v : [NSNull null]);
//    
////    if ([v isKindOfClass:[NSString class]]) {
////        return v ? v : @"";
////    }else{
////        return v ? v : [NSNull null];
////    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *name = nil;
    
    
    NSDictionary *dic = @{@"name" : ENSURE_NOTNULL(name)};
    
//    dic valueForKey:<#(nonnull NSString *)#>
    NSLog(@"dic = %@",dic[@"name"]);
}

@end
