//
//  MZViewController.m
//  Kolorz
//
//  Created by Mason Glaves on 4/29/12.
//  Copyright (c) 2012 Masonsoft. All rights reserved.
//

#import "MZViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MZViewController ()

@end

@implementation MZViewController {

    IBOutlet UILabel* hex;
    
    IBOutlet UIButton* nfo;
    
    IBOutletCollection(UIView) NSArray* colors; 
    
    UIView* correct;
    
    BOOL animating;
}

- (void) setColors {
    animating = NO;
    
    int which = arc4random_uniform(4);
    
    for (int i = 0; i < 4; i++) {
        [[colors objectAtIndex:i] setAlpha:1.0f];
        if (i == which) continue;
        [[colors objectAtIndex:i] setBackgroundColor:[UIColor colorWithRed:(arc4random_uniform(256) / 255.0f) green:(arc4random_uniform(256) / 255.0f) blue:(arc4random_uniform(256) / 255.0f) alpha:1.0f]];        
    }
    
    int red = arc4random_uniform(256);
    int green = arc4random_uniform(256);
    int blue = arc4random_uniform(256);
    
    correct = [colors objectAtIndex:which];
    [correct setBackgroundColor:[UIColor colorWithRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha:1.0f]];
    
    hex.text = [NSString stringWithFormat:@"#%02X%02X%02X", red, green, blue];
}

- (void) choose:(id)sender {    
    if (!animating) {
        animating = YES;
        
        [UIView animateWithDuration:1.5f animations:^{
            nfo.alpha = 0.0f;
            int wrong;            
            for (wrong = [colors indexOfObject:[sender view]];wrong == [colors indexOfObject:correct]; wrong = arc4random_uniform(4)); 
            
            for (int i = 0; i < 4; i++) {
                if (i != [colors indexOfObject:correct] && i != wrong) {
                    [[colors objectAtIndex:i] setAlpha:0.0f];
                }
            }                    
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.5f animations:^{                
                for (int i = 0; i < 4; i++) {
                    if ([colors objectAtIndex:i] != correct) {
                        [[colors objectAtIndex:i] setAlpha:0.0f];
                    }
                }                    
                
            } completion:^(BOOL finished) {
                __block CGRect last;
                [UIView animateWithDuration:1.0f animations:^{
                    last = correct.frame;
                    correct.frame = CGRectMake(20.0f, 30.0f, 280.0f, 420.0f);
                } completion:^(BOOL finished) {
                    sleep(1);
                    [UIView animateWithDuration:1.0f animations:^{
                        correct.frame = last;
                        nfo.alpha = 0.1f;
                        [self setColors];
                    }];        
                }];        
            }];        
        }];        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    for (int i = 0; i < 4; i++) {
        [[[colors objectAtIndex:i] layer] setCornerRadius:20];
        [[colors objectAtIndex:i] addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choose:)]];  
    }
    
}

- (void) viewDidAppear:(BOOL)animated {

    [UIView animateWithDuration:2.0f animations:^{
        [self setColors];
    }];        
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
