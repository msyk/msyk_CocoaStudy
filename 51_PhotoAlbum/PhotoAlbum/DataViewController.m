//
//  DataViewController.m
//  PhotoAlbum
//
//  Created by Masayuki Nii on 12/02/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataViewController.h"

@implementation DataViewController

@synthesize dataLabel = _dataLabel;
@synthesize dataObject = _dataObject;
@synthesize photoView = _photoView;
@synthesize scrollView = _scrollView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (UIView *)viewForZoomingInScrollView: (UIScrollView *)scrollView
{

    return self.photoView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    NSLog( @"scrollview bound = %@", NSStringFromCGRect(self.scrollView.bounds ));
    NSLog( @"scrollView frame = %@", NSStringFromCGRect(self.scrollView.frame ));
    NSLog( @"scrollview contentOffset = %@", NSStringFromCGPoint(self.scrollView.contentOffset ));
    NSLog( @"scrollView contentSize = %@", NSStringFromCGSize(self.scrollView.contentSize ));
    NSLog( @"scrollview contentInset = %@", NSStringFromUIEdgeInsets(self.scrollView.contentInset ));
    NSLog( @"scrollView %f / %f", self.scrollView.contentScaleFactor, self.scrollView.zoomScale );
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
    
    NSString *fileName = [self.dataObject description];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource: fileName 
                                                          ofType: @"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile: imagePath];
    self.photoView.image = image;
    CGRect photoRect = CGRectMake( 0.0, 0.0, image.size.width, image.size.height );
    self.photoView.bounds = photoRect;
    self.photoView.frame = photoRect;
    
    CGRect scrollRect = self.scrollView.bounds;
    CGRect imageRect = self.photoView.frame;
    self.scrollView.zoomScale = scrollRect.size.width / imageRect.size.width;
    self.scrollView.contentOffset = CGPointZero;
 //   self.scrollView.contentSize = CGSizeMake(10,10);//imageRect.size;
 //   self.scrollView.contentInset = UIEdgeInsetsMake(50, 50, 50, 50);
    /*
    self.scrollView.clipsToBounds = YES;
    self.view.clipsToBounds = YES;
    self.photoView.clipsToBounds = YES;
*/
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ( self.interfaceOrientation == UIInterfaceOrientationLandscapeRight 
        || self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ){
        for ( DataViewController *dvc in ((UIPageViewController *)self.parentViewController).viewControllers ) {
            NSLog( @"#### Scrollview's frame adjusted" );
            //CGRect scrollRect = CGRectMake( 0, 0, 432, 589);
            CGRect scrollRect = self.scrollView.bounds;
            dvc.scrollView.zoomScale = 1.0;
            dvc.photoView.frame = CGRectMake(0.0 , 0.0,
                                             dvc.photoView.frame.size.width, dvc.photoView.frame.size.height);
            CGRect imageRect = dvc.photoView.frame;
            dvc.scrollView.zoomScale = scrollRect.size.width / imageRect.size.width;
            dvc.scrollView.contentOffset = CGPointZero;
        //    dvc.scrollView.contentSize = scrollRect.size;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog( @"%@ # didRotateFromInterfaceOrientation:", self );
    self.scrollView.zoomScale = 1.0;
    self.photoView.frame = CGRectMake(0.0 , 0.0, 
                                      self.photoView.frame.size.width, self.photoView.frame.size.height);
    
    CGRect scrollRect = self.scrollView.bounds;
    CGRect imageRect = self.photoView.frame;
    self.scrollView.zoomScale = scrollRect.size.width / imageRect.size.width;
    self.scrollView.contentOffset = CGPointZero;
  //  self.scrollView.contentSize = scrollRect.size;
    NSLog( @"scrollview bound = %@", NSStringFromCGRect(self.scrollView.bounds ));
    NSLog( @"imageview frame = %@", NSStringFromCGRect(self.photoView.frame ));
}
@end
