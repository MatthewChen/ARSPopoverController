/*Copyright (c) 2014, Artem Sechko. All rights reserved.
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 1) Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 2) Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 3) All advertising materials mentioning features or use of this software must display the following acknowledgement:
 "This product includes software developed by the University of California, Berkeley and its contributors."
 4) Neither the name of the Arsynth nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ARSPopoverController.h"
#import "ARSBackingView.h"

@interface ARSPopoverContentView : UIView

@end

@implementation ARSPopoverContentView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Do not call super. It can forward message to backing view
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Do not call super. It can forward message to backing view
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Do not call super. It can forward message to backing view
}

@end

@interface ARSPopoverController () <ARSBackingViewDelegate>

@end

@implementation ARSPopoverController
@synthesize delegate = _delegate;
@synthesize presented = _presented;

#pragma mark ARSBackingViewDelegate

- (void)backingViewTouchUp:(ARSBackingView *)view
{
    if([_delegate respondsToSelector:@selector(popoverShouldDismiss:)])
        if([_delegate popoverShouldDismiss:self] == NO)
            return;
    
    [self dismissAnimated:NO];
    
    if([_delegate respondsToSelector: @selector(popover:didDismissAnimated:)])
        [_delegate popover:self didDismissAnimated:NO];
    
}

#pragma mark Overriden
- (id)initWithContentViewController:(UIViewController*)contentViewController
{
    if(self = [super init])
    {
        _contentView = [[ARSPopoverContentView alloc] initWithFrame:CGRectZero];
        _contentView.autoresizingMask = UIViewAutoresizingNone;
        
        _backingView = [[ARSBackingView alloc] initWithFrame:CGRectZero];
        _backingView.delegate = self;
        
        _contentViewController = contentViewController;
        
    }
    
    return self;
}

-(void)presentInRect:(CGRect)rect inView:(UIView*)view animated:(BOOL)animated
{
    _presented = YES;
    
    [_backingView present];
    
    _backingView.backgroundColor = [UIColor clearColor];
    _contentViewController.view.alpha = 0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    _backingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _contentViewController.view.alpha = 1.f;
    
    [UIView commitAnimations];
    
    [self updateInRect:rect inView:view animated:animated];

    [_contentView addSubview:_contentViewController.view];
    [_backingView addSubview:_contentView];
}

-(void)updateInRect:(CGRect)rect inView:(UIView*)view animated:(BOOL)animated
{
    rect = [_backingView convertRect:rect fromView:view];
    
    CGRect presentingRect = CGRectZero;
    presentingRect.size = [_contentViewController contentSizeForViewInPopover];
    
    _contentViewController.view.frame = CGRectMake(0.f,
                                                   0.f,
                                                   presentingRect.size.width,
                                                   presentingRect.size.height);
    
    presentingRect.origin.x = rect.origin.x + floorf((rect.size.width - presentingRect.size.width)/2.f);
    
    presentingRect.origin.y = rect.origin.y + floorf((rect.size.height - presentingRect.size.height)/2.f);
    
    _contentView.frame = presentingRect;
}

-(void)dismissAnimated:(BOOL)animated
{
    _presented = NO;
    
    void (^animBlock)() = ^()
    {
        _backingView.userInteractionEnabled = NO;
        _contentViewController.view.userInteractionEnabled = NO;
        _backingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _contentViewController.view.alpha = 0.f;
    };
    
    void (^endBlock)(BOOL isFinished) = ^(BOOL isFinished)
    {
        [_contentViewController.view removeFromSuperview];
        [_contentView removeFromSuperview];
        [_backingView dismiss];
        _backingView.userInteractionEnabled = YES;
        _contentViewController.view.userInteractionEnabled = YES;
    };
    
    [UIView animateWithDuration:0.25 animations:animBlock completion:endBlock];
}

@end
