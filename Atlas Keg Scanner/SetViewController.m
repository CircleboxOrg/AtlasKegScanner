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

//removing this due to Invalid Update error when deleting only row to go back to count = 0
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    if ([[[self scanSet] scans] count] > 0) {
//        
//        self.tableView.backgroundView = nil;
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        return 1;
//        
//    } else {
//        
//        // Display a message when the table is empty
//        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        
//        messageLabel.text = @"No scans in set.";
//        messageLabel.textColor = [UIColor blackColor];
//        messageLabel.numberOfLines = 0;
//        messageLabel.textAlignment = NSTextAlignmentCenter;
//        //messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
//        [messageLabel sizeToFit];
//        
//        self.tableView.backgroundView = messageLabel;
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//    }
//    
//    return 0;
//}

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
    self.title = [NSString stringWithFormat:@"%@ (%d)", self.scanSet.scanSetName,
                  (int)[[self.scanSet scans] count]];
    
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
    //self.scanSet.scanSetName = self.scanSetName.text;
    //self.title = self.scanSetName.text;
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Rename Scan Set" message:@"Enter set name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    //alertTextField.keyboardType = UIKeyboardTypeAlphabet;
    alertTextField.text = self.scanSet.scanSetName;
    
    
    [alert show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        self.scanSet.scanSetName = [[alertView textFieldAtIndex:0] text];
        //self.title = self.scanSet.scanSetName;
        self.title = [NSString stringWithFormat:@"%@ (%d)", self.scanSet.scanSetName,
                                    (int)[[self.scanSet scans] count]];

        
    }
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
    NSString *emailTitle = [NSString stringWithFormat: @"Keg scans - %@", _scanSet.scanSetName];
    // Email Content
    NSString *messageBody = @"Attached are the keg serial numbers.";
    NSMutableString *attachmentTxt = [NSMutableString stringWithString:@"" ];
    NSMutableString *attachmentCsv = [NSMutableString stringWithString:@"" ];
    for (id obj in _scanSet.scans) {
        Scan* s = (Scan *)obj;
        [attachmentTxt appendString: [s scanValue]];
        [attachmentTxt appendString:@"\r\n"];
        
        [attachmentCsv appendString: [s scanValue]];
        [attachmentCsv appendString:@"\n"];
    }
    NSString* filePathTxt = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"keg scans.txt"];
    
    
    [attachmentTxt writeToFile:filePathTxt atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    NSString* filePathCsv = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"keg scans.csv"];
    
    [attachmentCsv writeToFile:filePathCsv atomically:YES encoding:NSUTF16LittleEndianStringEncoding error:NULL];


    // To address
    //NSArray *toRecipents = [NSArray arrayWithObject:@"randall@atlaskegs.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    //[mc setToRecipients:toRecipents];
    NSData *attDataTxt = [NSData dataWithContentsOfFile:filePathTxt];
    NSData *attDataCsv = [NSData dataWithContentsOfFile:filePathCsv];
    
    [mc addAttachmentData:attDataTxt
                                 mimeType:@"text/plain"
                 fileName:[[_scanSet scanSetName] stringByAppendingString:@".txt"]];
    [mc addAttachmentData:attDataCsv
                 mimeType:@"text/csv"
                 fileName:[[_scanSet scanSetName] stringByAppendingString:@".csv"]];
    
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
