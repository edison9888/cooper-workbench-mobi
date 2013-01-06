//
//  SearchUserViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "SearchUserViewController.h"

@interface SearchUserViewController ()

@end

@implementation SearchUserViewController

@synthesize filterOptionArray;
@synthesize delegate;

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

        [delegate modifyAssignee:user];

        [self goBack:nil];
//        if([idObject isKindOfClass:[TeamMember class]])
//        {
//            TeamMember *teamMember = (TeamMember*)idObject;
//
//            currentProjectId = nil;
//            currentMemberId = teamMember.id;
//            currentTag = nil;
//        }
//        else if([idObject isKindOfClass:[Project class]])
//        {
//            Project *project = (Project*)idObject;
//
//            currentProjectId = project.id;
//            currentMemberId = nil;
//            currentTag = nil;
//        }
//        else if([idObject isKindOfClass:[Tag class]])
//        {
//            Tag *tag = (Tag*)idObject;
//
//            currentProjectId = nil;
//            currentMemberId = nil;
//            currentTag = tag.name;
//        }
    }
}

#pragma mark 私有方法

- (void)initContentView
{
    UILabel *textTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    textTitleLabel.backgroundColor = [UIColor clearColor];
    textTitleLabel.textAlignment = UITextAlignmentCenter;
    textTitleLabel.textColor = APP_TITLECOLOR;
    textTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.navigationItem.titleView = textTitleLabel;
    textTitleLabel.text = @"人员选择";

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(14, 16, 15, 10)];
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

    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(10, 12, 270, 44)];
    searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_assignee.png"]];

    searchText = [[[UITextField alloc] initWithFrame:CGRectMake(10, 13, 250, 20)] autorelease];
    searchText.font = [UIFont systemFontOfSize:16.0f];
    searchText.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:102.0/255];
    searchText.backgroundColor = [UIColor clearColor];
    searchText.keyboardType = UIKeyboardTypeDefault;
    searchText.keyboardAppearance = UIKeyboardAppearanceDefault;
    searchText.autocorrectionType = UITextAutocorrectionTypeNo;
    searchText.autocapitalizationType = UITextAutocapitalizationTypeNone;

    [searchView addSubview:searchText];

    [searchText becomeFirstResponder];

    UIView *assigneeChooseView = [[[UIView alloc] initWithFrame:CGRectMake(290, 24, 18, 18)] autorelease];
    UIButton *assigneeChooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [assigneeChooseBtn setBackgroundImage:[UIImage imageNamed:@"detailcreate_assigneeAdd.png"] forState:UIControlStateNormal];
    UITapGestureRecognizer *chooseRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchUser:)];
    [assigneeChooseView addGestureRecognizer:chooseRecognizer];
    [chooseRecognizer release];

    [assigneeChooseView addSubview:assigneeChooseBtn];
    
    [self.view addSubview:searchView];
    [self.view addSubview:assigneeChooseView];

    [assigneeChooseBtn release];
    [searchView release];

    filterView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 60, [Tools screenMaxWidth], [Tools screenMaxHeight] - 60) style:UITableViewStylePlain] autorelease];
    filterView.backgroundColor = [UIColor clearColor];
    filterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    filterView.delegate = self;
    filterView.dataSource = self;
    //去掉底部空白
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    filterView.tableFooterView = footer;
    [self.view addSubview: filterView];
}

- (void)searchUser:(id)sender
{
    [searchText resignFirstResponder];

    filterOptionArray = [[NSMutableArray alloc] init];

    self.HUD = [Tools process:@"用户搜索" view:self.view];

    NSString *workId = [[Constant instance] workId];
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"FindUsers" forKey:REQUEST_TYPE];
    [enterpriseService findUsers:workId key:searchText.text context:context delegate:self];
//    [enterpriseService getTaskDetail:currentTaskId context:context delegate:self];
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
