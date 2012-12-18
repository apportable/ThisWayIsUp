//
//  UpViewController.h
//  ThisWayIsUp
//
//  Copyright (c) 2012 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpViewController : UIViewController <UIAccelerometerDelegate>
@property (nonatomic, retain) IBOutlet UIImageView *coreMotionDirectionIndictator;
@property (nonatomic, retain) IBOutlet UIImageView *uiAccelerationDirectionIndictator;
@property (nonatomic, retain) IBOutlet UIButton *viewControllerPortraitButton;
@property (nonatomic, retain) IBOutlet UIButton *viewControllerLandcapeButton;
@property (nonatomic, retain) IBOutlet UIButton *viewControllerFreeButton;
@property (nonatomic, retain) IBOutlet UIButton *statusBarPortraitButton;
@property (nonatomic, retain) IBOutlet UIButton *statusBarPortraitUpsideDownButton;
@property (nonatomic, retain) IBOutlet UIButton *statusBarLandscapeLeftButton;
@property (nonatomic, retain) IBOutlet UIButton *statusBarLandscapeRightButton;
@property (nonatomic, retain) IBOutlet UILabel *coreMotionLabel;
@property (nonatomic, retain) IBOutlet UILabel *uiAccelerationLabel;
@property (nonatomic, retain) IBOutlet UIView *selectionView;
- (IBAction)viewControllerPortrait:(id)sender;
- (IBAction)viewControllerLandscape:(id)sender;
- (IBAction)viewControllerFreeRotate:(id)sender;
- (IBAction)statusBarPortrait:(id)sender;
- (IBAction)statusBarPortratUpsideDown:(id)sender;
- (IBAction)statusBarLandscapeLeft:(id)sender;
- (IBAction)statusBarLandscapeRight:(id)sender;
- (IBAction)toggleSelection:(id)sender;
@end
