//
//  BoostedMacros.h
//  BeatTheQ
//
//  Created by Ashemah Harrison on 21/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) /* */
#endif

#define ALog(...) NSLog(__VA_ARGS__)

#define bhPushVC_ARC(_vcname)                                           \
    _vcname *vc = [[_vcname alloc] init];                    \
    [self.navigationController pushViewController:vc animated:YES]   \

#define bhPushVCC_ARC(_vcname, _initMethod)                                \
    _vcname *vc = [[_vcname alloc] _initMethod];                    \
    [self.navigationController pushViewController:vc animated:YES]   \

#define bhPushVCCD_ARC(_vcname, _initMethod, _delegate)                                \
_vcname *vc = [[_vcname alloc] _initMethod];                    \
vc.delegate = _delegate;                                                    \
[self.navigationController pushViewController:vc animated:YES]   \


#define bhPresentModalVC(_vcname)                                           \
_vcname *vc = [[[_vcname alloc] init] autorelease];                    \
[self presentModalViewController:vc animated:YES]   \

#define bhPresentModalVCC(_vcname, _initMethod)                                \
_vcname *vc = [[[_vcname alloc] _initMethod] autorelease];                    \
[self presentModalViewController:vc animated:YES]   

#define bhViewMove(_view, _x, _y) _view.frame               = CGRectMake(_x, _y, _view.frame.size.width, _view.frame.size.height)
#define bhViewPlaceBelow(_above, _below) _below.frame       = CGRectMake(_below.frame.origin.x, _above.frame.origin.y + _above.frame.size.height, _below.frame.size.width, _below.frame.size.height)
#define bhViewSetHeight(_view, _height) _view.frame         = CGRectMake(_view.frame.origin.x, _view.frame.origin.y, _view.frame.size.width, _height);

#define bhSetupRequest(_method)                                    \
NSLog(@"URL %@", r.url);                                      \
r.delegate = self;   \
r.validatesSecureCertificate = NO; \
r.timeOutSeconds        = 60; \
[r setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];\
r.didStartSelector  = @selector(_method ## DidStart:);        \
r.didFinishSelector = @selector(_method ## DidSucceed:);      \
r.didFailSelector   = @selector(_method ## DidFail:);         \

#define bhSetupRequest2(_r)                                    \
NSLog(@"URL %@", _r.url);                                      \
_r.delegate = self;   \
_r.timeOutSeconds        = 60; \
[_r setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];\

#define bhDelegateRespondsTo(_method) (self.delegate && [self.delegate respondsToSelector:@selector(_method)])

#define bhSmartDateString(_formatter, _date) ((_date != nil) ? ([_formatter stringFromDate:_date]) : ([NSNull null]))
#define bhSmartDateFromString(_formatter, _date) ((_date != [NSNull null]) ? ([_formatter dateFromString:_date]) : (nil))

#define bhSmartProperty(_property) ((_property != nil) ? (_property) : ([NSNull null]))
#define bhSmartStringProperty(_property) ((_property != nil) ? (_property) : (@""))
