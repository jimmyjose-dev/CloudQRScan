#import <MessageUI/MessageUI.h>
#import "EGOPhotoSource.h"
#import "EGOPhotoGlobal.h"
#import "CFShareCircleView.h"
#import "ShareController.h"
@class EGOPhotoImageView, EGOPhotoCaptionView;
@interface EGOPhotoViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate,CFShareCircleViewDelegate> {
@private
	id <EGOPhotoSource> _photoSource;
	EGOPhotoCaptionView *_captionView;
	NSMutableArray *_photoViews;
	UIScrollView *_scrollView;
    
	NSInteger _pageIndex;
	BOOL _rotating;
	BOOL _barsHidden;
    
	UIBarButtonItem *_leftButton;
	UIBarButtonItem *_rightButton;
	UIBarButtonItem *_actionButton;
    
	BOOL _storedOldStyles;
	UIStatusBarStyle _oldStatusBarSyle;
	UIBarStyle _oldNavBarStyle;
	BOOL _oldNavBarTranslucent;
	UIColor* _oldNavBarTintColor;
	UIBarStyle _oldToolBarStyle;
	BOOL _oldToolBarTranslucent;
	UIColor* _oldToolBarTintColor;
	BOOL _oldToolBarHidden;
    
	BOOL _autoresizedPopover;
	id _popover;
    
	BOOL _fullScreen;
	BOOL _fromPopover;
	UIView *_popoverOverlay;
	UIView *_transferView;
    
}

- (id)initWithPhoto:(id<EGOPhoto>)aPhoto;

- (id)initWithImage:(UIImage*)anImage;
- (id)initWithImageURL:(NSURL*)anImageURL;

- (id)initWithPhotoSource:(id <EGOPhotoSource>)aPhotoSource;
- (id)initWithPhotoSource:(id <EGOPhotoSource> )aPhotoSource andTitle:(NSString *)title;

- (id)initWithPopoverController:(id)aPopoverController photoSource:(id <EGOPhotoSource>)aPhotoSource;

@property(nonatomic,readonly) id <EGOPhotoSource> photoSource;
@property(nonatomic,retain) NSMutableArray *photoViews;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,assign) BOOL _fromPopover;
@property (nonatomic, retain) CFShareCircleView *shareCircleView;
@property (nonatomic, retain) ShareController *shareController;


- (NSInteger)currentPhotoIndex;
- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated;

@end