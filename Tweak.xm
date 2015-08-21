@interface SBAppSwitcherPeopleScrollView : UIScrollView
@end

@interface SBAppSwitcherPeopleViewController : UIViewController
@end

@interface SBAppSwitcherPageViewController : UIViewController
@end

@interface SBAppSwitcherIconController : UIViewController
@end

@interface SBAppSwitcherController : UIViewController
-(SBAppSwitcherPageViewController *)pageController;
@end

static CGRect appViewFrame;
static CGRect iconViewFrame;
static CGRect origFrame;
static CGRect screenRect = [[UIScreen mainScreen] bounds];
static CGFloat screenHeight = screenRect.size.height;
static CGFloat screenWidth = screenRect.size.width;

static float duration = 0.4;

%hook SBAppSwitcherController

-(void)animateDismissalToDisplayLayout:(id)arg1 withCompletion:(/*^block*/id)arg2 {

	[UIView animateWithDuration:duration animations:^{
		CGFloat scale;
		if (screenHeight > 600) { //iphone 6
			scale = 162;
		} else {
			scale = 143;
		}
		self.pageController.view.frame = CGRectMake(0,scale,origFrame.size.width,origFrame.size.height);
	}];
	%orig;
}

%end

%hook SBAppSwitcherPageViewController

-(void)_layoutItemContainer:(id)arg1 {
	
	%orig;
	origFrame = self.view.frame;
	[UIView animateWithDuration:duration animations:^{
		self.view.frame = appViewFrame = CGRectMake(origFrame.origin.x,50,origFrame.size.width,origFrame.size.height);
	}];

}

%end

%hook SBAppSwitcherIconController 

-(void)setDisplayLayouts:(NSArray *)arg1 {
	%orig;
	CGRect origIconFrame = self.view.frame;
	[UIView animateWithDuration:duration animations:^{
		self.view.frame = iconViewFrame = CGRectMake(origIconFrame.origin.x,appViewFrame.size.height + 40,origIconFrame.size.width,origIconFrame.size.height);
	}];
}
%end

%hook SBAppSwitcherPeopleViewController

-(void)switcherWillBePresented:(BOOL)arg1 {

    %orig;
	CGRect origPeopleFrame = self.view.frame;
	self.view.frame = CGRectMake(origPeopleFrame.origin.x,screenHeight - 150,origPeopleFrame.size.width,origPeopleFrame.size.height);

}

%end
