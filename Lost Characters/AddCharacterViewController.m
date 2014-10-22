    //
//  AddCharacterViewController.m
//  Lost Characters
//
//  Created by Taylor Wright-Sanson on 10/21/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "AddCharacterViewController.h"

@interface AddCharacterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextField *textField5;
@property (weak, nonatomic) IBOutlet UITextField *textField6;

@end

@implementation AddCharacterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.textField1 addTarget:self.textField2 action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.textField2 addTarget:self.textField3 action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.textField3 addTarget:self.textField4 action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.textField4 addTarget:self.textField5 action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.textField5 addTarget:self.textField6 action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.textField6 addTarget:self action:@selector(onDidFinishAddingNewCharacter:) forControlEvents:UIControlEventEditingDidEndOnExit];

}

- (IBAction)onDidFinishAddingNewCharacter:(UITextField *)textField
{
    NSError *error = nil;
    NSManagedObject *newCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.managedObjectContext];

    [newCharacter setValue:self.textField1.text forKey:@"passenger"];
    [newCharacter setValue:self.textField2.text forKey:@"hairColor"];
    [newCharacter setValue:self.textField3.text forKey:@"planeSeat"];
    [newCharacter setValue:self.textField4.text forKey:@"age"];
    [newCharacter setValue:self.textField5.text forKey:@"shoeSize"];
    [newCharacter setValue:self.textField5.text forKey:@"sex"];

    if ([self.managedObjectContext save:&error]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        NSLog(@"Error: %@",error.localizedDescription);
    }
}

- (IBAction)dismissAddCharacterView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
