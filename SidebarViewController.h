//
//  LeftSidebarViewController.h
//  JTRevealSidebarDemo
//
//  Created by James Apple Tang on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideBarTableViewCell.h"
#import "HeadView.h"
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"

@protocol SidebarViewControllerDelegate;

@interface SidebarViewController : UITableViewController<HeadViewDelegate, UIAlertViewDelegate>
{
   
    NSInteger _currentSection;
    NSInteger _currentRow;
  
    

}
@property (nonatomic, assign) id <SidebarViewControllerDelegate> sidebarDelegate;
@property(nonatomic, retain) NSMutableArray* headViewArray;
@property (nonatomic,retain) UIViewController *rootVc;
@end

@protocol SidebarViewControllerDelegate <NSObject>

- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(SidebarViewController *)sidebarViewController;

@end
