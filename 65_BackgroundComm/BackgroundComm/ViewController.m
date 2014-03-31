//
//  ViewController.m
//  BackgroundComm
//
//  Created by Masayuki Nii on 2014/03/31.
//  Copyright (c) 2014年 msyk.net. All rights reserved.
//

#import "ViewController.h"
#import "BGCommunication.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *message;

@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) BGCommunication *bgc;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.message.text = @"";
    self.progress.progress = 0.0;
    self.queue = [[NSOperationQueue alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapButton:(id)sender {
    NSURL *url = [NSURL URLWithString: @"https://server.msyk.net/10m.txt"];
    self.message.text = @"Downloading";
    void(^progress)(float rate) = ^(float rate)    {
        self.progress.progress = rate;
    };
    NSBlockOperation *finish = [NSBlockOperation blockOperationWithBlock: ^(){
        self.message.text = self.bgc.downloadedFile.path;
    }];
    self.bgc = [[BGCommunication alloc] initWithURL: url
                                    doProgress: progress
                                       doAfter: finish];
    [self.queue addOperation: self.bgc];
    
}
@end
