//
//  GTLServiceAnalytics+Public.m
//  Lytics
//
//  Created by Jens Andersson on 8/26/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "GTLServiceAnalytics+Public.h"

@implementation GTLServiceAnalytics (Public)

GTLServiceAnalytics *_service;

+ (GTLServiceAnalytics *)shared {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _service = [[GTLServiceAnalytics alloc] init];
    });
    
    return _service;
}

@end
