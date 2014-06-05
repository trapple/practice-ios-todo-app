//
//  MasterViewController.m
//  ToDo
//
//  Created by 増田 博志 on 2014/05/28.
//  Copyright (c) 2014年 vivi-design. All rights reserved.
//

#import "MasterViewController.h"
#import "NewViewController.h"

@interface MasterViewController () {
    NSMutableArray *todos;
}
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!todos) {
        todos = [[NSMutableArray alloc] init];
    }
    [todos insertObject:sender atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Sectionの数
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // セルの数
    return todos.count;
}

// セルに値を設定する
// これはセルの数だけ呼び出される
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"indexPath=%d", indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UITextField *textField = cell.contentView.subviews[0];
    textField.text = todos[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [todos removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *task = todos[fromIndexPath.row];
    [todos removeObjectAtIndex:fromIndexPath.row];
    [todos insertObject:task atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (IBAction)unwindToMaster:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"save"]) {
        NewViewController *controller = (NewViewController *)segue.sourceViewController;
        [self insertNewObject:controller.textField.text];
    }
}

- (IBAction)endEditing:(UITextField *)sender {
    CGPoint point = [sender convertPoint:sender.center toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    [todos replaceObjectAtIndex:indexPath.row withObject:sender.text];
}

- (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths[0] stringByAppendingPathComponent:@"todo.dat"];
    return filePath;
}

- (void)dataLoad
{
    NSLog(@"call load method");
    todos = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    //NSLog(@"%@", todos);
}

- (void)dataSave
{
    NSLog(@"call save method");
    [NSKeyedArchiver archiveRootObject:todos toFile:[self filePath]];
}


@end
