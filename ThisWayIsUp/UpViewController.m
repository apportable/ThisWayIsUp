//
//  UpViewController.m
//  ThisWayIsUp
//
//  Copyright (c) 2012 Apportable. All rights reserved.
//

#import "UpViewController.h"
#import <CoreMotion/CoreMotion.h>

typedef enum {
    UpViewControllerModeUnspecified,
    UpViewControllerModePortrait,
    UpViewControllerModeLandscape,
    UpViewControllerModeFreeRotate
} UpViewControllerMode;

@implementation UpViewController {
    UpViewControllerMode mode;
    CMMotionManager *motionManager;
    NSString *uiAccelerationText;
    NSString *cmAccelerationText;
    int cmRot;
    int uiRot;
}

@synthesize coreMotionDirectionIndictator;
@synthesize uiAccelerationDirectionIndictator;
@synthesize viewControllerPortraitButton;
@synthesize viewControllerLandcapeButton;
@synthesize viewControllerFreeButton;
@synthesize statusBarPortraitButton;
@synthesize statusBarPortraitUpsideDownButton;
@synthesize statusBarLandscapeLeftButton;
@synthesize statusBarLandscapeRightButton;
@synthesize coreMotionLabel;
@synthesize uiAccelerationLabel;
@synthesize selectionView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self toggleSelection:nil];
    [self viewControllerPortrait:nil];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    motionManager = [[CMMotionManager alloc] init];
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error){
        float theta = 0.0f - atan2f(accelerometerData.acceleration.y, accelerometerData.acceleration.x) - M_PI_2;
        [self setCMAccelerationDirection:theta];
    }];
}

- (void)dealloc
{
    self.coreMotionDirectionIndictator = nil;
    self.uiAccelerationDirectionIndictator = nil;
    self.viewControllerPortraitButton = nil;
    self.viewControllerLandcapeButton = nil;
    self.viewControllerFreeButton = nil;
    self.statusBarPortraitButton = nil;
    self.statusBarPortraitUpsideDownButton = nil;
    self.statusBarLandscapeLeftButton = nil;
    self.statusBarLandscapeRightButton = nil;
    self.coreMotionLabel = nil;
    self.uiAccelerationLabel = nil;
    self.selectionView = nil;
    [super dealloc];
}

- (IBAction)viewControllerPortrait:(id)sender
{
    if (mode != UpViewControllerModePortrait)
    {
        mode = UpViewControllerModePortrait;
        [self.viewControllerPortraitButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.viewControllerLandcapeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.viewControllerFreeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self toggleSelection:sender];
    }
}

- (IBAction)viewControllerLandscape:(id)sender
{
    if (mode != UpViewControllerModeLandscape)
    {
        mode = UpViewControllerModeLandscape;
        [self.viewControllerPortraitButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.viewControllerLandcapeButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.viewControllerFreeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self toggleSelection:sender];
    }
}

- (IBAction)viewControllerFreeRotate:(id)sender
{
    if (mode != UpViewControllerModeFreeRotate)
    {
        mode = UpViewControllerModeFreeRotate;
        [self.viewControllerPortraitButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.viewControllerLandcapeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.viewControllerFreeButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self toggleSelection:sender];
    }
}

- (IBAction)statusBarPortrait:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
}

- (IBAction)statusBarPortratUpsideDown:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortraitUpsideDown];
}

- (IBAction)statusBarLandscapeLeft:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
}

- (IBAction)statusBarLandscapeRight:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

- (IBAction)toggleSelection:(id)sender
{
    self.selectionView.hidden = !self.selectionView.hidden;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    switch (mode)
    {
        case UpViewControllerModePortrait:
            return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
        case UpViewControllerModeLandscape:
            return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
        case UpViewControllerModeFreeRotate:
        default:
            return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    switch (mode)
    {
        case UpViewControllerModeLandscape:
            return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
        case UpViewControllerModePortrait:
            return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
        case UpViewControllerModeFreeRotate:
            return YES;
        default:
            return NO;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    float theta = 0.0f - atan2f(acceleration.y, acceleration.x) - M_PI_2;
    [self setUiAccelerationDirection:theta];
}

- (void)setCMAccelerationDirection:(float)theta
{
    float deg = theta / (2 * M_PI) * 360.0f;
    NSString *text = [NSString stringWithFormat:@"%0.2f", deg];
    if (![cmAccelerationText isEqualToString:text])
    {
        [cmAccelerationText release];
        cmAccelerationText = [text copy];
        self.coreMotionLabel.text = cmAccelerationText;
    }
    switch (self.interfaceOrientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            deg += 180.0f;
            break;
        case UIInterfaceOrientationLandscapeRight:
            deg += 270.0f;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            deg += 90.0f;
            break;
        case UIInterfaceOrientationPortrait:
            break;
    }
    if (deg < 0.0f)
    {
        deg += 360.0f;
    }
    else if (deg > 360.0f)
    {
        deg -= 360.0f;
    }
    if (337.5 <= deg || deg < 22.5f)
    {
        self.coreMotionDirectionIndictator.image = [UIImage imageNamed:@"0c.png"];
    }
    else if (22.5f <= deg && deg < 67.5f)
    {
        self.coreMotionDirectionIndictator.image = [UIImage imageNamed:@"45c.png"];
    }
    else if (67.5 <= deg && deg < 112.5)
    {
        self.coreMotionDirectionIndictator.image = [UIImage imageNamed:@"90c.png"];
    }
    else if (112.5 <= deg && deg < 157.5)
    {
        self.coreMotionDirectionIndictator.image = [UIImage imageNamed:@"135c.png"];
    }
    else if (157.5 <= deg && deg < 202.5)
    {
        self.coreMotionDirectionIndictator.image = [UIImage imageNamed:@"180c.png"];
    }
    else if (202.5 <= deg && deg < 247.5)
    {
        self.coreMotionDirectionIndictator.image = [UIImage imageNamed:@"225c.png"];
    }
    else if (247.5 <= deg && deg < 292.5)
    {
        self.coreMotionDirectionIndictator.image = [UIImage imageNamed:@"270c.png"];
    }
    else if (292.5 <= deg && deg < 337.5)
    {
        self.coreMotionDirectionIndictator.image = [UIImage imageNamed:@"315c.png"];
    }
}

- (void)setUiAccelerationDirection:(float)theta
{
    float deg = theta / (2 * M_PI) * 360.0f;
    NSString *text = [NSString stringWithFormat:@"%0.2f", deg];
    if (![uiAccelerationText isEqualToString:text])
    {
        [uiAccelerationText release];
        uiAccelerationText = [text copy];
        self.uiAccelerationLabel.text = uiAccelerationText;
    }
    switch (self.interfaceOrientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            deg += 180.0f;
            break;
        case UIInterfaceOrientationLandscapeRight:
            deg += 270.0f;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            deg += 90.0f;
            break;
        case UIInterfaceOrientationPortrait:
            break;
    }
    if (deg < 0.0f)
    {
        deg += 360.0f;
    }
    else if (deg > 360.0f)
    {
        deg -= 360.0f;
    }
    if (337.5 <= deg || deg < 22.5f)
    {
        self.uiAccelerationDirectionIndictator.image = [UIImage imageNamed:@"0.png"];
    }
    else if (22.5f <= deg && deg < 67.5f)
    {
        self.uiAccelerationDirectionIndictator.image = [UIImage imageNamed:@"45.png"];
    }
    else if (67.5 <= deg && deg < 112.5)
    {
        self.uiAccelerationDirectionIndictator.image = [UIImage imageNamed:@"90.png"];
    }
    else if (112.5 <= deg && deg < 157.5)
    {
        self.uiAccelerationDirectionIndictator.image = [UIImage imageNamed:@"135.png"];
    }
    else if (157.5 <= deg && deg < 202.5)
    {
        self.uiAccelerationDirectionIndictator.image = [UIImage imageNamed:@"180.png"];
    }
    else if (202.5 <= deg && deg < 247.5)
    {
        self.uiAccelerationDirectionIndictator.image = [UIImage imageNamed:@"225.png"];
    }
    else if (247.5 <= deg && deg < 292.5)
    {
        self.uiAccelerationDirectionIndictator.image = [UIImage imageNamed:@"270.png"];
    }
    else if (292.5 <= deg && deg < 337.5)
    {
        self.uiAccelerationDirectionIndictator.image = [UIImage imageNamed:@"315.png"];
    }
}


@end
