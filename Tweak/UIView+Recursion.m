#include "UIView+Recursion.h"

@implementation UIView (Recursion)
- (UIViewController *)parentViewController {
  UIResponder *responder = self;
  while ([responder isKindOfClass:[UIView class]]) responder = [responder nextResponder];
  return (UIViewController *)responder;
}
@end