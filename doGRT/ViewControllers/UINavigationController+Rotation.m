//
//  UINavigationController+Rotation.m
//  doGRT
//
//  Created by Greg Wang on 12-9-24.
//
//

#import "UINavigationController+Rotation.h"

@implementation UINavigationController (Rotation)

#pragma From UINavigationController

- (BOOL)shouldAutorotate {
	
    BOOL result = YES; // self.topViewController.shouldAutorotate;
	
    return result;
}

- (NSUInteger)supportedInterfaceOrientations {
	
    NSUInteger result = UIInterfaceOrientationMaskAllButUpsideDown; // self.topViewController.supportedInterfaceOrientations;
	
    return result;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

@end
