//
//  SetViewController.m
//  Atlas Keg Scanner
//
//  Created by Family on 5/21/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

#import "SetViewController.h"
#import "ScannerViewController.h"

@interface SetViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;


@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Button action functions
- (IBAction)scanButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"scan" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"scan"]) {
        
        ScannerViewController *destViewController = segue.destinationViewController;
        destViewController.scanSet = [self scanSet];
        //destViewController.delegate = self;
        
    }
    if ([segue.identifier isEqualToString:@"edit"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ScanEditViewController *destViewController = segue.destinationViewController;
        destViewController.scan = [self.scanSet.scans objectAtIndex:indexPath.row];
        
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self scanSet ] scans] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ScanCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [(Scan *)[[[self scanSet] scans] objectAtIndex:indexPath.row] scanValue];
    return cell;
}

- (void) refreshData {
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.tableView reloadData];
    self.scanSetName.text = self.scanSet.scanSetName;
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

- (IBAction)scanSetNameUpdate:(id)sender {
    self.scanSet.scanSetName = self.scanSetName.text;
    self.title = self.scanSetName.text;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Scan *scan = [self.scanSet.scans objectAtIndex:indexPath.row ];
        [self.scanSet.scans removeObject:scan];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (IBAction)sendEmailClick:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Keg scans";
    // Email Content
    NSString *messageBody = @"Attached are the keg serial numbers.";
    NSMutableString *attachment = [NSMutableString stringWithString:@"" ];
    for (id obj in _scanSet.scans) {
        Scan* s = (Scan *)obj;
        [attachment appendString: [s scanValue]];
        [attachment appendString:@"\r\n"];
    }
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"keg scans.txt"];
    [attachment writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];

    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"randall@atlaskegs.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    NSData *attData = [NSData dataWithContentsOfFile:filePath];
    
    [mc addAttachmentData:attData
                                 mimeType:@"text/plain"
                 fileName:[[_scanSet scanSetName] stringByAppendingString:@".txt"]];
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
