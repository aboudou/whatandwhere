//
//  UserAnnotation.m
//  What and Where
//
//  Created by Arnaud Boudou on 13/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserAnnotation.h"


@implementation UserAnnotation

@synthesize coordinate;

-(NSString *) title {
    return NSLocalizedString(@"Here", @"UserAnnotation title");
}

-(NSString *) subtitle {
    return nil;
}

@end
