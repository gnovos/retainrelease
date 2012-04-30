//
//  MZInfoViewController.m
//  Kolorz
//
//  Created by Mason Glaves on 4/30/12.
//  Copyright (c) 2012 Masonsoft. All rights reserved.
//

#import "MZInfoViewController.h"

@interface MZInfoViewController ()

@end

@implementation MZInfoViewController {
    IBOutlet UIImageView* sigl;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    sigl.alpha = 0.05f;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:2.0f animations:^{
        sigl.alpha = 0.2f; 
    } completion:^(BOOL finished) {
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
