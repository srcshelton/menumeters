//
//  NSMenuExtraBase.m
//  MenuMeters
//
//  Created by Yuji on 2015/08/01.
//
//

#import "MenuMetersMenuExtraBase.h"

@implementation MenuMetersMenuExtraBase

- (instancetype)initWithBundle: (NSBundle*)bundle {
	self = [super initWithBundle:bundle];
	return self;
}

- (void)timerFired: (id)notused {
	statusItem.menu = self.menu;
	NSImage*canvas = [[NSImage alloc] initWithSize:NSMakeSize(self.length, self.view.frame.size.height)];
	[canvas lockFocus];
	[self.view drawRect:NSMakeRect(0, 0, canvas.size.width, canvas.size.height)];
	[canvas unlockFocus];
	statusItem.button.image = canvas;
}

- (void)configDisplay: (NSString*)bundleID fromPrefs:(MenuMeterDefaults*)ourPrefs withTimerInterval:(NSTimeInterval)interval {
	if ([ourPrefs loadBoolPref:bundleID defaultValue:YES]) {
		if (!statusItem) {
			statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
		}
		[timer invalidate];
		timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
		[timer setTolerance:.2*interval];
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
	} else if (![ourPrefs loadBoolPref:bundleID defaultValue:YES] && statusItem) {
		[timer invalidate];
		[[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
		statusItem = nil;
	}
}

@end
