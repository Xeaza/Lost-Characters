//
//  MasterViewController.m
//  Lost Characters
//
//  Created by Taylor Wright-Sanson on 10/21/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AddCharacterViewController.h"
#import "LostCharacterTableViewCell.h"

@interface MasterViewController ()
@property NSArray *characters;
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;

    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];

    // If there's nothing in coredata go fetch the plist of default objects
    if (results.count == 0)
    {
        NSArray *lostCharacters = [[NSArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/2/lost.plist"]];
        NSLog(@"%@",lostCharacters);

        for (NSDictionary *characterDict in lostCharacters)
        {
            NSError *error = nil;
            NSManagedObject *newCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.managedObjectContext];

            [newCharacter setValue:characterDict[@"actor"] forKey:@"actor"];
            [newCharacter setValue:characterDict[@"passenger"] forKey:@"passenger"];

            if ([self.managedObjectContext save:&error]) {
                [self loadData];
            }
            else {
                NSLog(@"Error: %@",error.localizedDescription);
            }
        }
        [self.tableView reloadData];
    }
    else
    {
        [self loadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadData];
}

- (void)loadData
{
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"passenger" ascending:YES];
    // Don't really want a predicate. But could use one for further sorting
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"passenger = 'worsley'"];
    // Got this line from apple docs. Unlike the above the line can be uppwercase or lowercase.
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"passenger LIKE[c] 'Worsley'"];
    //request.predicate = predicate;
    request.sortDescriptors = @[sortDescriptor1];

    self.characters = [self.managedObjectContext executeFetchRequest:request error:nil];

    if (!error) {
        [self.tableView reloadData];
    }
    else {
        NSLog(@"Error: %@",error.localizedDescription);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddCharacterSegue"])
    {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSManagedObject *character = [self.characters objectAtIndex:indexPath.row];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.characters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LostCharacterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSManagedObject *character = [self.characters objectAtIndex:indexPath.row];

    NSString *age, *hairColor, *seat, *shoeSize;
    if ([character valueForKey:@"age"]) {
        age = [@"Age: " stringByAppendingString:[character valueForKey:@"age"]];
    }
    else {
        age = @"";
    }
    if ([character valueForKey:@"hairColor"]) {
        hairColor = [@"Hair Color: " stringByAppendingString:[character valueForKey:@"hairColor"]];
    }
    else {
        hairColor = @"";
    }
    if ([character valueForKey:@"planeSeat"]) {
        seat = [@"Seat: " stringByAppendingString:[character valueForKey:@"planeSeat"]];
    }
    else {
        seat = @"";
    }
    if ([character valueForKey:@"shoeSize"]) {
        shoeSize = [@"Shoe Size: " stringByAppendingString:[character valueForKey:@"shoeSize"]];
    }
    else {
        shoeSize = @"";
    }


    cell.nameLabel.text        = [character valueForKey:@"passenger"];
    cell.ageLabel.text         = age;
    cell.hairColorLabel.text   = hairColor;
    cell.seatLabel.text        = seat;
    cell.sexLabel.text         = [character valueForKey:@"sex"];
    cell.shoeSizeLabel.text    = shoeSize;
    cell.image.image = [UIImage imageWithData:[character valueForKey:@"image"]];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.managedObjectContext deleteObject:[self.characters objectAtIndex:indexPath.row]];

        NSError *error = nil;
        if (![self.managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self loadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"SMOKE MONSTER";
}

@end
