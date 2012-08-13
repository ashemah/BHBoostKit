//
//  NoIndentTableViewCell.m
//  BeatTheQ
//
//  Created by Ashemah Harrison on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGImageCell.h"

@implementation BGImageCell

@synthesize state;

//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    }
    return self;
}

//
- (void)setupCellWithPrefix:(NSString*)prefix offState:(NSString*)offSuffix onState:(NSString*)onSuffix position:(NSString*)position capSize:(int)capSize {
    
    NSString *imageName;
    NSString *selImageName;
    
    imageName       = [NSString stringWithFormat:@"%@_%@_%@.png", prefix, offSuffix, position];
    selImageName    = [NSString stringWithFormat:@"%@_%@_%@.png", prefix, onSuffix, position];
    
    [self setupCellWithImageName:imageName selectedImageName:selImageName capSize:capSize];
}

//
- (void)setupCellWithPrefix:(NSString*)prefix offState:(NSString*)offSuffix onState:(NSString*)onSuffix capSize:(int)capSize {
    
    NSString *imageName;
    NSString *selImageName;
    NSString *imageState;
            
    imageName       = [NSString stringWithFormat:@"%@_%@.png", prefix, offSuffix, imageState];
    selImageName    = [NSString stringWithFormat:@"%@_%@.png", prefix, onSuffix, imageState];
    
    [self setupCellWithImageName:imageName selectedImageName:selImageName capSize:capSize];
}

//
- (void)setupCellWithImageName:(NSString*)imageName selectedImageName:(NSString*)selImageName capSize:(int)capSize {
    
    if (!self.backgroundView) {
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    
    self.selectedBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    //
    UIImageView *bgView     = (UIImageView*)self.backgroundView;
    UIImageView *selBgView  = (UIImageView*)self.selectedBackgroundView;
    
    //
    UIImage *image  = [UIImage imageNamed:imageName];
    image           = [image stretchableImageWithLeftCapWidth:capSize topCapHeight:capSize];                
    
    //
    UIImage *selImage   = [UIImage imageNamed:selImageName];
    selImage            = [selImage stretchableImageWithLeftCapWidth:capSize topCapHeight:capSize];                
    
    // Set it
    bgView.image        = image;
    selBgView.image     = selImage;    
}

//
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(0,                                          
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width, 
                                        self.contentView.frame.size.height);
    
    if (self.editing
        && ((state & UITableViewCellStateShowingEditControlMask)
            && !(state & UITableViewCellStateShowingDeleteConfirmationMask)) || 
        ((state & UITableViewCellStateShowingEditControlMask)
         && (state & UITableViewCellStateShowingDeleteConfirmationMask))) 
    {
        float indentPoints = self.indentationLevel * self.indentationWidth;
        
        self.contentView.frame = CGRectMake(indentPoints,
                                            self.contentView.frame.origin.y,
                                            self.contentView.frame.size.width - indentPoints, 
                                            self.contentView.frame.size.height);    
    }
}

- (void)willTransitionToState:(UITableViewCellStateMask)aState {
    [super willTransitionToState:aState];
    self.state = aState;
}

@end
