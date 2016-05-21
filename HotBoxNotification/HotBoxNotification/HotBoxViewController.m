//
//  HotBoxViewController.m
//

#import "HotBoxViewController.h"
#import "Masonry.h"

@interface HotBoxViewController ()

@property (strong, nonatomic) UITapGestureRecognizer* tapGesture;
@property (strong, nonatomic) UISwipeGestureRecognizer* swipeGesture;
@property (weak, nonatomic) HotBox* owner;

@end

@implementation HotBoxViewController

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark -

- (instancetype)initWithOwner:(HotBox *)owner
{
    if(self = [super init]) {
        [self setOwner:owner];
    }
    return self;
}

- (void)tapGestureActivated:(UITapGestureRecognizer *)sender
{
    if([self.delegate respondsToSelector:@selector(hotBoxWasTapped:)]) {
        [self.delegate hotBoxWasTapped:self.notificationType];
    }
    
    if(!self.hasButton) {
        // if box was tapped avoid calling expiration delegate method on dismissal
        _delegate = nil;

        [self.owner dismiss];
    }
}

- (void)swipeGestureActivated:(UISwipeGestureRecognizer *)sender
{
    if([self.delegate respondsToSelector:@selector(hotBoxWasSwiped:)]) {
        [self.delegate hotBoxWasSwiped:self.notificationType];
    }
    
    // avoid calling expiration delegate method on dismissal
    _delegate = nil;
    
    [self.owner dismiss];
}

- (void)buttonTapped:(id)sender
{
    if([self.delegate respondsToSelector:@selector(hotBoxButtonWasTapped:)]) {
        [self.delegate hotBoxButtonWasTapped:self.notificationType];
    }
    
    // if button was tapped avoid calling expiration delegate method on dismissal
    _delegate = nil;
    
    [self.owner dismiss];
}

- (NSString *)messageString
{
    return [[self.messageLabel attributedText] string];
}


#pragma mark -

- (NSString *)notificationType
{
    if (!_notificationType) {
        _notificationType = @"";
    }
    return _notificationType;
}

- (BOOL)hasButton
{
    return self.buttonTitle.length;
}

- (UITapGestureRecognizer *)tapGesture
{
    if(!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureActivated:)];
    }
    return _tapGesture;
}

- (UISwipeGestureRecognizer *)swipeGesture
{
    if(!_swipeGesture) {
        _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureActivated:)];
        [_swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    }
    return _swipeGesture;
}

- (UILabel *)messageLabel
{
    if(!_messageLabel) {
        _messageLabel = [UILabel new];
        [_messageLabel setNumberOfLines:0];
    }
    return _messageLabel;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    [self.imageView setImage:_image];
}

- (UIImageView *)imageView
{
    if(!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.image];
    }
    return _imageView;
}

- (UIButton *)actionButton
{
    if(!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

@synthesize buttonTitle = _buttonTitle;

- (NSString *)buttonTitle
{
    if(!_buttonTitle) {
        _buttonTitle = @"";
    }
    return _buttonTitle;
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    
    [self.actionButton setTitle:_buttonTitle forState:UIControlStateNormal];
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setGestureRecognizers:@[ self.tapGesture, self.swipeGesture ]];
    [self.view setUserInteractionEnabled:YES];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.messageLabel];
    [self.view addSubview:self.actionButton];
    
    if(self.buttonTitle.length)
        [self.actionButton setTitle:self.buttonTitle forState:UIControlStateNormal];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.leading.equalTo(self.view.mas_leading).offset(15);
        make.width.equalTo(@(self.imageView.image.size.width));
        make.height.equalTo(@(self.imageView.image.size.height));
    }];

    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.equalTo(self.imageView.mas_trailing).offset(10);
        if(self.buttonTitle.length)
            make.trailing.equalTo(self.actionButton.mas_leading).offset(-15);
        else
            make.trailing.equalTo(self.view.mas_trailing).offset(-15);
    }];
    
    [self.messageLabel setContentCompressionResistancePriority:250 forAxis:UILayoutConstraintAxisHorizontal];
    
    if(self.buttonTitle.length)
        [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view.mas_centerY);
            make.trailing.equalTo(self.view.mas_trailing).offset(-15);
        }];
    
    [super updateViewConstraints];
}

@end
