//
//  MedicalContactCell.m
//  HealthVive
//
//  Created by Adarsha on 27/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "MedicalContactCell.h"

@implementation MedicalContactCell
{
    UIButton *customEditBtn;
}
@synthesize myContentView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    panRecognizer.delegate = self;
    [self addGestureRecognizer:panRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)panThisCell:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            //self.panStartPoint = [recognizer translationInView:self.myContentView];
            //NSLog(@"Pan Began at %@", NSStringFromCGPoint(self.panStartPoint));
            break;
        case UIGestureRecognizerStateChanged: {
            //CGPoint currentPoint = [recognizer translationInView:self.myContentView];
           // CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
           // NSLog(@"Pan Moved %f", deltaX);
        }
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Pan Ended");
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"Pan Cancelled");
            break;
        default:
            break;
    }
}




@end
