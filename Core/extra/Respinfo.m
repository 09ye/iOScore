//
//  state.m
//  Core
//
//  Created by sheely on 13-9-13.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "Respinfo.h"
#import <UIKit/UIKit.h>
@implementation Respinfo

@synthesize code = _code;
@synthesize message = _message;

- (id)initWithCode:(int)code message:(NSString*)message
{
    if(self = [self init]){
        _code = code;
        _message = message;
    }
    return self;
}
-(void) show
{
#if DEBUG
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message: [NSString stringWithFormat:@"(%d)\n%@",self.code,self.message ] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
#else
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:self.message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
#endif
    [alert show];
}


-(NSString*)description
{
    return [NSString stringWithFormat:@"%d--%@",_code,_message];
}
@end
