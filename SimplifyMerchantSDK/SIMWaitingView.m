#import "SIMWaitingView.h"

@interface SIMWaitingView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIView *transparentView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SIMWaitingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 1.0;
        
        UIView *transparentView = [[UIView alloc] initWithFrame:CGRectZero];
        transparentView.backgroundColor = [UIColor blackColor];
        transparentView.alpha = 0.5;
        transparentView.layer.cornerRadius = 4.0;
        [self addSubview:transparentView];
        self.transparentView = transparentView;

        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = @"Please wait";
        [self addSubview:textLabel];
        self.textLabel = textLabel;

        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:self.activityIndicatorView];
        
    }
    return self;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect rect = self.frame;
    CGRect halfSizeRect = CGRectMake(0, 0, rect.size.width/2.0, rect.size.height/2.0);
    CGRect quarterSizeRect = CGRectMake(0, 0, halfSizeRect.size.width/2.0, halfSizeRect.size.height/2.0);
    CGPoint center = CGPointMake(rect.size.width /2.0, rect.size.height / 2.0);

    self.transparentView.frame = halfSizeRect;
    self.transparentView.center = center;
    self.textLabel.frame = quarterSizeRect;
    self.textLabel.center = CGPointMake(center.x, center.y + quarterSizeRect.size.height/2.0);
    
    self.activityIndicatorView.center = center;
    
    [self bringSubviewToFront:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
}

@end
