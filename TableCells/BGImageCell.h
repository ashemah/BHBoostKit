//
//  BGImageCell.h
//  DistractMe
//
//  Created by Ashemah Harrison on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGImageCell : UITableViewCell {
}

@property (nonatomic, assign) int state;

- (void)setupCellWithImageName:(NSString*)imageName selectedImageName:(NSString*)selImageName capSize:(int)capSize;
- (void)setupCellWithPrefix:(NSString*)prefix offState:(NSString*)offSuffix onState:(NSString*)onSuffix position:(NSString*)position capSize:(int)capSize;
- (void)setupCellWithPrefix:(NSString*)prefix offState:(NSString*)offSuffix onState:(NSString*)onSuffix capSize:(int)capSize;

@end
