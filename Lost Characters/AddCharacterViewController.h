//
//  AddCharacterViewController.h
//  Lost Characters
//
//  Created by Taylor Wright-Sanson on 10/21/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AddCharacterViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
