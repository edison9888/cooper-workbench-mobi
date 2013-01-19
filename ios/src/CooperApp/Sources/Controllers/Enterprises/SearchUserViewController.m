//
//  SearchUserViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "SearchUserViewController.h"

@implementation SearchUserViewController

@synthesize filterOptionArray;
@synthesize delegate;
@synthesize type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    enterpriseService = [[EnterpriseService alloc] init];
    currentIndex = -1;
    filterOptionArray = [[NSMutableArray alloc] init];
//    [filterOptionArray addObject:@"萧玄"];
//    [filterOptionArray addObject:@"何望"];
	[self initContentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [filterOptionArray release];
    [enterpriseService release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - tableView 数据源

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filterOptionArray count];
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if(tableView == filterView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FilterOptionCell"];
        if(!cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterOptionCell"] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.row == currentIndex)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        NSMutableDictionary *user = [filterOptionArray objectAtIndex:indexPath.row];
        NSString *name = [user objectForKey:@"name"];
        cell.textLabel.text = name;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        cell.textLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == filterView)
    {
        if(indexPath.row == currentIndex)
        {
            return;
        }
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];

        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        if (newCell.accessoryType == UITableViewCellAccessoryNone) {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
        if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
        currentIndex = indexPath.row;

        NSMutableDictionary *user = [[filterOptionArray objectAtIndex:indexPath.row] copy];

        if(type == 0) {
            [delegate modifyAssignee:user];
        }
        else if(type == 1) {
            [delegate modifyRelated:user];
        }
        else if(type == 2) {
            [delegate writeName:[user objectForKey:@"name"]];
        }
        [self goBack:nil];
    }
}

#pragma mark 私有方法

- (void)initContentView
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_bg.png"]];
    
    UILabel *textTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    textTitleLabel.backgroundColor = [UIColor clearColor];
    textTitleLabel.textAlignment = UITextAlignmentCenter;
    textTitleLabel.textColor = APP_TITLECOLOR;
    textTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.navigationItem.titleView = textTitleLabel;
    textTitleLabel.text = @"人员选择";

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.userInteractionEnabled = NO;
    [backBtn setFrame:CGRectMake(9, 17, 15, 10)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [backView addSubview:backBtn];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    [backView addGestureRecognizer:backRecognizer];
    [backRecognizer release];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backView release];

    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 50, 40)];
    //searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_assignee.png"]];

    searchBarText = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 00, self.view.bounds.size.width, 40)] autorelease];
    searchBarText.delegate = self;
    searchBarText.barStyle = UIBarStyleBlack;
    searchBarText.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBarText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBarText.placeholder = @"搜索";
    searchBarText.keyboardType =  UIKeyboardTypeDefault;
    searchBarText.tintColor = [UIColor colorWithRed:93.0/255 green:81.0/255 blue:73.0/255 alpha:1];
    [searchView addSubview:searchBarText];
    
//    for (UIView *subview in searchBarText.subviews) {
//        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//            [subview removeFromSuperview];
//            break;
//        }  
//    }
    
//    searchText = [[[UITextField alloc] initWithFrame:CGRectMake(10, 13, 250, 20)] autorelease];
//    searchText.font = [UIFont systemFontOfSize:16.0f];
//    searchText.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
//    searchText.backgroundColor = [UIColor clearColor];
//    searchText.keyboardType = UIKeyboardTypeDefault;
//    searchText.keyboardAppearance = UIKeyboardAppearanceDefault;
//    searchText.autocorrectionType = UITextAutocorrectionTypeNo;
//    searchText.returnKeyType = UIReturnKeySearch;
//    searchText.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    [searchText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
//
//    [searchView addSubview:searchText];

    [searchText becomeFirstResponder];

//    UIView *assigneeChooseView = [[[UIView alloc] initWithFrame:CGRectMake(284, 11, 36, 44)] autorelease];
//    UIButton *assigneeChooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 12, 18, 18)];
//    assigneeChooseBtn.userInteractionEnabled = NO;
//    [assigneeChooseBtn setBackgroundImage:[UIImage imageNamed:@"detailcreate_assigneeAdd.png"] forState:UIControlStateNormal];
//    UITapGestureRecognizer *chooseRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchUser:)];
//    [assigneeChooseView addGestureRecognizer:chooseRecognizer];
//    [chooseRecognizer release];
//
//    [assigneeChooseView addSubview:assigneeChooseBtn];
    
    [self.view addSubview:searchView];

    [searchView release];

    filterView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 40) style:UITableViewStylePlain] autorelease];
    filterView.backgroundColor = [UIColor clearColor];
    filterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    filterView.delegate = self;
    filterView.dataSource = self;
    //去掉底部空白
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    filterView.tableFooterView = footer;
    [self.view addSubview: filterView];
}

-(void)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
    
    [self searchUser:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [self searchUser:nil];
}

- (void)searchUser:(id)sender
{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSearch:) object:nil];
//    [self performSelector:@selector(startSearch:) withObject:nil afterDelay:0.5];

    filterOptionArray = [[NSMutableArray alloc] init];
    
    self.HUD = [Tools process:@"用户搜索" view:self.view];
    
    NSString *workId = [[Constant instance] workId];
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"FindUsers" forKey:REQUEST_TYPE];
    [enterpriseService findUsers:workId key:searchBarText.text context:context delegate:self];
}

- (void)goBack:(id)sender
{
    [Tools layerTransition:self.navigationController.view from:@"left"];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);

    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];

    if([requestType isEqualToString:@"FindUsers"])
    {
        if(request.responseStatusCode == 200)
        {
            [Tools close:self.HUD];

            NSDictionary *dict = [[request responseString] JSONValue];
            if(dict)
            {
                NSNumber *state = [dict objectForKey:@"state"];

                if(state == [NSNumber numberWithInt:0]) {

                    NSMutableArray *data = [dict objectForKey:@"data"];

                    if([data isEqual:[NSNull null]]) {
                        return;
                    }

                    for (NSMutableDictionary *user in data) {
                        NSString *workId = [user objectForKey:@"id"];
                        NSString *name = [user objectForKey:@"name"];

                        NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
                        [userDict setObject:workId forKey:@"workId"];
                        [userDict setObject:name forKey:@"name"];

                        [filterOptionArray addObject:userDict];
                    }    

                    [filterView reloadData];
                }
                else {
                    NSString *errorMsg = [dict objectForKey:@"errorMsg"];
                    [Tools failed:self.HUD msg:errorMsg];
                }
            }
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
}

@end
