//
//  ALRadialButton.m
//  ALRadial
//
//  Created by andrew lattis on 12/10/14.
//  Copyright (c) 2012 andrew lattis. All rights reserved.
//  http://andrewlattis.com
//

#import "ALRadialButton.h"

@implementation ALRadialButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)willAppear {
	//rotate the button upsidedown so its right side up after the 180 degree rotation while its moving out
    [self runSpinAnimationOnView:self.imageView duration:0.25 rotations:5 repeat:2];
    
	self.alpha = 1.0;

	[UIView animateWithDuration:.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{

		[self setCenter:self.bouncePoint];
		
	} completion:^(BOOL finished) {
		
		[UIView animateWithDuration:.15f animations:^{
			//a little bounce back at the end
			[self setCenter:self.centerPoint];
		}];
		
	}];
}


- (void)willDisappear {
	[UIView animateWithDuration:.15f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
		
		//first do the rotate in place animation
//		[self.imageView setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, -(180/180*M_PI))];
        [self runSpinAnimationOnView:self.imageView duration:0.25 rotations:7 repeat:0];
	
	} completion:^(BOOL finished) {
		
		[UIView animateWithDuration:.5f animations:^{
			//now move it back to the origin button
			[self setCenter:self.originPoint];
			self.alpha = 0.0f;
		} completion:^(BOOL finished) {
			//finally hide the button and tell the delegate we are done so it can cleanup memory
			
			[self.delegate buttonDidFinishAnimation:self];
		}];
		
	}];
}

@end
