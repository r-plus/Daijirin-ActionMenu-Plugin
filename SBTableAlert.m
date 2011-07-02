//
//  SBTableAlert.m
//  SBTableAlert
//
//  Created by Simon Blommegård on 2011-04-08.
//  Copyright 2011 Simon Blommegård. All rights reserved.
//

#import "SBTableAlert.h"
#import <QuartzCore/QuartzCore.h>

@interface SBTableViewTopShadowView : UIView {}
@end

@implementation SBTableViewTopShadowView

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();

	// Draw top shadow
	CGFloat colors [] = { 
		0, 0, 0, 0.4,
		0, 0, 0, 0,
	};
	
	CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
	CGColorSpaceRelease(baseSpace), baseSpace = NULL;
	
	CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
	CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), 8);
	
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	CGGradientRelease(gradient), gradient = NULL;
}

@end

@interface SBTableView : UITableView {
	SBTableAlertStyle _alertStyle;
}
@property (nonatomic) SBTableAlertStyle alertStyle;
@end

@implementation SBTableView

@synthesize alertStyle=_alertStyle;

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (_alertStyle == SBTableAlertStyleApple) {
		// Draw background gradient
		CGFloat colors [] = { 
			0.922, 0.925, 0.933, 1,
			0.749, 0.753, 0.761, 1,
		};
		
		CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
		CGColorSpaceRelease(baseSpace), baseSpace = NULL;
		
		CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
		CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
		
		CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
		CGGradientRelease(gradient), gradient = NULL;
	}
	
	[super drawRect:rect];
}

@end

@interface SBTableAlertCellContentView : UIView
@end

@implementation SBTableAlertCellContentView
- (void)drawRect:(CGRect)r {
	[(SBTableAlertCell *)[[self superview] superview] drawCellContentView:r];
}
@end

@implementation SBTableAlertCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		CGRect frame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		
		_cellContentView = [[SBTableAlertCellContentView alloc] initWithFrame:frame];
		[_cellContentView setBackgroundColor:[UIColor clearColor]];
		[_cellContentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		[self.contentView addSubview:_cellContentView];
		[self.contentView bringSubviewToFront:_cellContentView];
		[_cellContentView release];
		
		[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:nil usingBlock:^(NSNotification *not) {
			[self setNeedsDisplay];
		}];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	float editingOffset = 0.;
	if (self.editing)
		editingOffset = -self.contentView.frame.origin.x;
	
	_cellContentView.frame = CGRectMake(editingOffset,
																			_cellContentView.frame.origin.y,
																			self.frame.size.width - editingOffset,
																			_cellContentView.frame.size.height);
	
	[self.textLabel setBackgroundColor:[UIColor clearColor]];
	[self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
	[self setBackgroundColor:[UIColor clearColor]];
	
	[self setNeedsDisplay];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[_cellContentView setNeedsDisplay];
}

- (void)drawCellContentView:(CGRect)r {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1.5);
		
	[[UIColor colorWithWhite:1 alpha:0.8] set];
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, self.bounds.size.width, 0);
	CGContextStrokePath(context);
		
	[[UIColor colorWithWhite:0 alpha:0.35] set];
	CGContextMoveToPoint(context, 0, self.bounds.size.height);
	CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
	CGContextStrokePath(context);
}

@end

@interface SBTableAlert ()

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)format args:(va_list)args;
- (void)increaseHeightBy:(CGFloat)delta;
- (void)layout;

@end

@implementation SBTableAlert

@synthesize view=_alertView;
@synthesize tableView=_tableView;
@synthesize type=_type;
@synthesize style=_style;
@synthesize delegate=_delegate;
@synthesize dataSource=_dataSource;


- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)format args:(va_list)args {
	if ((self = [super init])) {
		NSString *message = format ? [[[NSString alloc] initWithFormat:format arguments:args] autorelease] : nil;
		
		_alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
		
		_tableView = [[SBTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		[_tableView setDelegate:self];
		[_tableView setDataSource:self];
		[_tableView setBackgroundColor:[UIColor whiteColor]];
		[_tableView setRowHeight:kDefaultRowHeight];
		[_tableView setSeparatorColor:[UIColor lightGrayColor]];
		_tableView.layer.cornerRadius = kTableCornerRadius;
		
		[_alertView addSubview:_tableView];
		
		_shadow = [[SBTableViewTopShadowView alloc] initWithFrame:CGRectZero];
		[_shadow setBackgroundColor:[UIColor clearColor]];
		[_shadow setHidden:YES];
		
		[_alertView addSubview:_shadow];
		[_alertView bringSubviewToFront:_shadow];
		
		[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:nil usingBlock:^(NSNotification *n) {
			dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^{[self layout];});
		}];
	}
	
	return self;
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ... {
	va_list list;
	va_start(list, message);
	self = [self initWithTitle:title cancelButtonTitle:cancelTitle messageFormat:message args:list];
	va_end(list);
	return self;
}

- (void)dealloc {
	[self setTableView:nil];
	[self setView:nil];
	
	[_shadow release], _shadow = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

#pragma mark -

- (void)show {
	[_tableView reloadData];
	[_alertView show];
}

#pragma mark - Properties

- (void)setStyle:(SBTableAlertStyle)style {
	if (style == SBTableAlertStyleApple) {
		[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[_tableView setAlertStyle:SBTableAlertStyleApple];
		[_shadow setHidden:NO];
	} else if (style == SBTableAlertStylePlain) {
		[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
		[_tableView setAlertStyle:SBTableAlertStylePlain];
		[_shadow setHidden:YES];
	}
	_style = style;
}

#pragma mark - Private

- (void)increaseHeightBy:(CGFloat)delta {
	CGPoint c = _alertView.center;
	CGRect r = _alertView.frame;
	r.size.height += delta;
	_alertView.frame = r;
	_alertView.center = c;
	_alertView.frame = CGRectIntegral(_alertView.frame);
	
	for(UIView *subview in [_alertView subviews]) {
		if([subview isKindOfClass:[UIControl class]]) {
			CGRect frame = subview.frame;
			frame.origin.y += delta;
			subview.frame = frame;
		}
	}
}


- (void)layout {
	NSInteger visibleRows = [_tableView numberOfRowsInSection:0];
	
	if (visibleRows > kNumMaximumVisibleRowsInTableView)
	visibleRows = kNumMaximumVisibleRowsInTableView;
	
	[self increaseHeightBy:(_tableView.rowHeight * visibleRows)];
	if ([_alertView message])
		[_tableView setFrame:CGRectMake(12, 75, _alertView.frame.size.width - 24, (_tableView.rowHeight * visibleRows))];
	else
		[_tableView setFrame:CGRectMake(12, 50, _alertView.frame.size.width - 24, (_tableView.rowHeight * visibleRows))];
	
	[_shadow setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, 8)];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_type == SBTableAlertTypeSingleSelect)
		[_alertView dismissWithClickedButtonIndex:-1 animated:YES];
	
	if ([_delegate respondsToSelector:@selector(tableAlert:didSelectRow:)])
		[_delegate tableAlert:self didSelectRow:[indexPath row]];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return [_dataSource tableAlert:self	cellForRow:[indexPath row]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_dataSource numberOfRowsInTableAlert:self];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertViewCancel:(UIAlertView *)alertView {
	if ([_delegate respondsToSelector:@selector(tableAlertCancel:)])
		[_delegate tableAlertCancel:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([_delegate respondsToSelector:@selector(tableAlert:clickedButtonAtIndex:)])
		[_delegate tableAlert:self clickedButtonAtIndex:buttonIndex];
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
	if (!_presented)
		[self layout];
	_presented = YES;
	if ([_delegate respondsToSelector:@selector(willPresentTableAlert:)])
		[_delegate willPresentTableAlert:self];
}
- (void)didPresentAlertView:(UIAlertView *)alertView {
	if ([_delegate respondsToSelector:@selector(didPresentTableAlert:)])
		[_delegate didPresentTableAlert:self];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([_delegate respondsToSelector:@selector(tableAlert:willDismissWithButtonIndex:)])
		[_delegate tableAlert:self willDismissWithButtonIndex:buttonIndex];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	_presented = NO;
	if ([_delegate respondsToSelector:@selector(tableAlert:didDismissWithButtonIndex:)])
		[_delegate tableAlert:self didDismissWithButtonIndex:buttonIndex];
}

@end
