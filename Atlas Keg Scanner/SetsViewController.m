//
//  ViewController.m
//  Atlas Keg Scanner
//
//  Created by Family on 5/17/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

#import "AppDelegate.h"
#import "SetsViewController.h"
#import "ScanSet.h"
#import "SetViewController.h"
@interface SetsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

@implementation SetsViewController {
    NSMutableArray *scanSets;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    scanSets = [appDelegate scanSets];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [scanSets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ScanSetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [(ScanSet *)[scanSets objectAtIndex:indexPath.row] scanSetName];
    return cell;
}

- (IBAction)editSet
{
    if([self.tableView isEditing]) {
        [self.tableView setEditing: false];
        [self.editButton setTitle:@"Edit"];
    }
    else {
        
        [self.editButton setTitle:@"Done"];
        [self.tableView setEditing: true];
    }
}
- (IBAction)addSet
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add Scan Set" message:@"Enter set name:" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    //alertTextField.keyboardType = UIKeyboardTypeAlphabet;
    alertTextField.placeholder = @"Enter your name";
    
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    ScanSet *ss;
    ss = [[ScanSet alloc] init];
    ss.scanSetName = [[alertView textFieldAtIndex:0] text];
    [scanSets addObject:ss];
    [self.tableView reloadData];
    
    
    AudioServicesPlaySystemSound (1054);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //BATTrailsViewController *trailsController = [[BATTrailsViewController alloc] initWithStyle:UITableViewStylePlain];
    //trailsController.selectedRegion = [regions objectAtIndex:indexPath.row];
    //[[self navigationController] pushViewController:trailsController animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showScanSetDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SetViewController *destViewController = segue.destinationViewController;
        destViewController.scanSet = [scanSets objectAtIndex:indexPath.row];
        destViewController.title = [[scanSets objectAtIndex:indexPath.row] scanSetName];
    }
    
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ScanSet *scanSet = [scanSets objectAtIndex:indexPath.row ];
                            [scanSets removeObject:scanSet];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) refreshData {
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.tableView reloadData];
}

@end
