//
//  GRTFlipsideViewController.m
//  doGRT
//
//  Created by Greg Wang on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GRTFlipsideViewController.h"
#import "GRTMainViewController.h"
#import "UserChosenBusStop.h"

@interface GRTFlipsideViewController ()
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSMutableArray *busStopArray;
@property (retain, nonatomic) NSNumber *chosenIndex;
@end

@implementation GRTFlipsideViewController

@synthesize busStopCell = _busStopCell;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize busStopArray = _busStopArray;
@synthesize chosenIndex = _chosenIndex;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.title = @"Bus Stops";
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	self.managedObjectContext = [(id) [[UIApplication sharedApplication] delegate]managedObjectContext];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserChosenBusStop" 
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"addTime" 
																   ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	NSMutableArray *mutableFetchResults = 
	[[self.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	self.busStopArray = mutableFetchResults;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions


#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.busStopArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"busStopCell";
	
    // Dequeue or create a new cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = self.busStopCell;
        self.busStopCell = nil;
    }
	
    UserChosenBusStop *busStop = (UserChosenBusStop *)[self.busStopArray objectAtIndex:indexPath.row];
	
    cell.textLabel.text = [NSString stringWithString:busStop.stopName];
	
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [busStop.stopId integerValue]];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView 
		commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
		forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // Delete the managed object at the given index path.
        UserChosenBusStop *busStop = [self.busStopArray objectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:busStop];
		
        // Update the array and table view.
        [self.busStopArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
						 withRowAnimation:YES];
		
        // Commit the change.
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	self.chosenIndex = [NSNumber numberWithInteger:indexPath.row];
	return indexPath;
}

#pragma mark - Adding View

- (void)addingViewControllerDidFinishWithBusStopNumber:(NSNumber *)busStopNumber
									   withBusStopName:(NSString *)busStopName{
	if(busStopNumber){
		// Create and configure a new instance of the Event entity.
		UserChosenBusStop *busStop = 
			(UserChosenBusStop *)[NSEntityDescription 
								  insertNewObjectForEntityForName:@"UserChosenBusStop" 
								  inManagedObjectContext:self.managedObjectContext];
		
		busStop.stopId = busStopNumber;
		busStop.stopName = busStopName;
		busStop.addTime = [NSDate date];
		
		NSError *error = nil;
		if (![self.managedObjectContext save:&error]) {
			// Handle the error.
		}
		
		[self.busStopArray insertObject:busStop atIndex:[self.busStopArray count]];
		[self.tableView reloadData];
	}
	else {
		// nil
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Segue setting

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAdding"]) {
        [[segue destinationViewController] setDelegate:self];
    }
	else if([[segue identifier] isEqualToString:@"showTimeTable"]) {
		GRTMainViewController *vc = (GRTMainViewController *)[segue destinationViewController];
		assert([vc isKindOfClass:[GRTMainViewController class]]);
		UserChosenBusStop *busStop = (UserChosenBusStop *) [self.busStopArray objectAtIndex:[self.chosenIndex unsignedIntegerValue]];
		
		vc.busStopNumber = busStop.stopId;
		vc.busStopName = busStop.stopName;
	}
}

@end
