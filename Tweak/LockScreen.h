#import "Ablaze.h"
#include "AblazeRemoteViewController.h"

@interface MTMaterialView : UIView
@end

@interface PLPlatterView : UIView
@property MTMaterialView *backgroundMaterialView;
@end

@interface CSAdjunctItemView : UIView
@property PLPlatterView *platterView;
@end

@interface CSAdjunctListItem : NSObject
@property NSString *identifier;
@property CSAdjunctItemView *platterView;
@end

@interface CSCoverSheetViewController : UIViewController
@property(getter=isShowingMediaControls) bool showingMediaControls;
@property(nonatomic, retain) UIView *ablazeView;
@property(nonatomic, strong) NSProxy *ablazeProxy;
@end