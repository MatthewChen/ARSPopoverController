/*Copyright (c) 2014, Artem Sechko. All rights reserved.
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 1) Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 2) Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 3) All advertising materials mentioning features or use of this software must display the following acknowledgement:
 "This product includes software developed by the University of California, Berkeley and its contributors."
 4) Neither the name of the Arsynth nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ViewController.h"
#import "ARSPopoverController.h"
#import "DemoViewController.h"

@interface ViewController ()

@property (nonatomic, strong) ARSPopoverController *popover;

@end

@implementation ViewController

- (IBAction)btnShowPopoverTouchUp:(id)sender
{
    [self.popover presentInRect:self.view.bounds inView:self.view animated:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if(self.popover.presented)
    {
        [self.popover updateInRect:self.view.bounds inView:self.view animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DemoViewController *ctl = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"demoCtl"];
    
    self.popover = [[ARSPopoverController alloc] initWithContentViewController:ctl];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
