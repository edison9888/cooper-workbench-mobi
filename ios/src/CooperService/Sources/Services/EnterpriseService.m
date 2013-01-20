//
//  EnterpriseService.m
//  CooperService
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseService.h"

@implementation EnterpriseService
- (ASIHTTPRequest*)getTodoTasks:(NSString*)workId
                        context:(NSMutableDictionary*)context
                       delegate:(id)delegate
{
    NSString *url = [[[Constant instance] rootPath] stringByAppendingFormat:ENTERPRISE_GETTODOTASKS_URL];
    NSLog(@"【GetTodoTasks服务接口路径】%@", url);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:workId forKey:@"workId"];
    //[params setObject:[NSNumber numberWithInt:1] forKey:@"includeCompleted"];

    HttpWebRequest *httpRequest = [[HttpWebRequest alloc] init];
    ASIHTTPRequest *request = [httpRequest postAsync:url params:params headers:nil context:context delegate:delegate];
    [httpRequest release];
    return request;
}
- (ASIHTTPRequest*)getRelevantTasks:(NSString*)workId
                 context:(NSMutableDictionary*)context
                delegate:(id)delegate
{
    NSString *url = [[[Constant instance] rootPath] stringByAppendingFormat:ENTERPRISE_GETRELEVANTTASKS_URL];
    NSLog(@"【GetRelevantTasks服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:workId forKey:@"workId"];
    
    HttpWebRequest *httpRequest = [[HttpWebRequest alloc] init];
    ASIHTTPRequest *request = [httpRequest postAsync:url params:params headers:nil context:context delegate:delegate];
    [httpRequest release];
    return request;
}
- (ASIHTTPRequest*)getTaskDetail:(NSString*)taskId
              context:(NSMutableDictionary*)context
             delegate:(id)delegate
{
    NSString *url = [[[Constant instance] rootPath] stringByAppendingFormat:ENTERPRISE_TASKDETAIL_URL];
    NSLog(@"【TaskDetail服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"loadAttachment"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"loadFeedback"];
    
    HttpWebRequest *httpRequest = [[HttpWebRequest alloc] init];
    ASIHTTPRequest *request = [httpRequest postAsync:url params:params headers:nil context:context delegate:delegate];
    [httpRequest release];
    return request;
}
- (ASIHTTPRequest*)changeTaskCompleted:(NSString*)taskId
                isCompleted:(NSNumber*)isCompleted
                    context:(NSMutableDictionary*)context
                   delegate:(id)delegate
{
    NSString *url = [[[Constant instance] rootPath] stringByAppendingFormat:ENTERPRISE_CHANGETASKCOMPLETED_URL];
    NSLog(@"【ChangeTaskCompleted服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    [params setObject:isCompleted forKey:@"isCompleted"];
    
    HttpWebRequest *httpRequest = [[HttpWebRequest alloc] init];
    ASIHTTPRequest *request = [httpRequest postAsync:url params:params headers:nil context:context delegate:delegate];
    [httpRequest release];
    return request;
}
- (ASIHTTPRequest*)changeTaskDueTime:(NSString*)taskId
                  dueTime:(NSString*)dueTime
                  context:(NSMutableDictionary*)context
                 delegate:(id)delegate
{
    NSString *url = [[[Constant instance] rootPath] stringByAppendingFormat:ENTERPRISE_CHANGETASKDUETIME_URL];
    NSLog(@"【ChangeTaskDueTime服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    [params setObject:dueTime forKey:@"dueTime"];
    
    HttpWebRequest *httpRequest = [[HttpWebRequest alloc] init];
    ASIHTTPRequest *request = [httpRequest postAsync:url params:params headers:nil context:context delegate:delegate];
    [httpRequest release];
    return request;
}
- (ASIHTTPRequest*)changeTaskPriority:(NSString*)taskId
                  priority:(NSNumber*)priority
                   context:(NSMutableDictionary*)context
                  delegate:(id)delegate
{
    NSString *url = [[[Constant instance] rootPath] stringByAppendingFormat:ENTERPRISE_CHANGETASKPRIORITY_URL];
    NSLog(@"【ChangeTaskPriority服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    [params setObject:priority forKey:@"priority"];
    
    HttpWebRequest *httpRequest = [[HttpWebRequest alloc] init];
    ASIHTTPRequest *request = [httpRequest postAsync:url params:params headers:nil context:context delegate:delegate];
    [httpRequest release];
    return request;
}
- (ASIHTTPRequest*)updateTask:(NSString*)taskId
           subject:(NSString*)subject
              body:(NSString*)body
           dueTime:(NSString*)dueTime
    assigneeWorkId:(NSString*)assigneeWorkId
relatedUserWorkIds:(NSString*)relatedUserWorkIds
          priority:(NSNumber*)priority
       isCompleted:(NSNumber*)isCompleted
     attachmentIds:(NSString*)attachmentIds
           context:(NSMutableDictionary*)context
          delegate:(id)delegate
{
    NSString *url = [[[Constant instance] rootPath] stringByAppendingFormat:ENTERPRISE_UPDATETASK_URL];
    NSLog(@"【UpdateTask服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"id"];
    [params setObject:subject forKey:@"subject"];
    [params setObject:body forKey:@"body"];
    [params setObject:dueTime forKey:@"dueTime"];
    [params setObject:assigneeWorkId forKey:@"assigneeWorkId"];
    [params setObject:relatedUserWorkIds forKey:@"relatedUserWorkIds"];
    [params setObject:priority forKey:@"priority"];
    [params setObject:isCompleted forKey:@"isCompleted"];
    [params setObject:attachmentIds forKey:@"attachmentIds"];
    
    HttpWebRequest *httpRequest = [[HttpWebRequest alloc] init];
    ASIHTTPRequest *request = [httpRequest postAsync:url params:params headers:nil context:context delegate:delegate];
    [httpRequest release];
    return request;
}
- (ASIHTTPRequest*)createTask:(NSString*)userId
           subject:(NSString*)subject
              body:(NSString*)body
           dueTime:(NSString*)dueTime
    assigneeUserId:(NSString*)assigneeUserId
   relatedUserJson:(NSString*)relatedUserJson
          priority:(NSNumber*)priority
           context:(NSMutableDictionary*)context
          delegate:(id)delegate
{
    NSString *url = [[[Constant instance] rootPath] stringByAppendingFormat:ENTERPRISE_CREATETASK_URL];
    NSLog(@"【CreateTask服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userId forKey:@"userId"];
    [params setObject:subject forKey:@"subject"];
    [params setObject:body forKey:@"body"];
    [params setObject:dueTime forKey:@"dueTime"];
    [params setObject:assigneeUserId forKey:@"assigneeUserId"];
    [params setObject:relatedUserJson forKey:@"relatedUserJson"];
    [params setObject:priority forKey:@"priority"];
    
    HttpWebRequest *httpRequest = [[HttpWebRequest alloc] init];
    ASIHTTPRequest *request = [httpRequest postAsync:url params:params headers:nil context:context delegate:delegate];
    [httpRequest release];
    return request;
}
- (ASIHTTPRequest*)newTask:(NSString*)creatorWorkId
        subject:(NSString*)subject
        dueTime:(NSString*)dueTime
 assigneeWorkId:(NSString*)assigneeWorkId
       priority:(NSNumber*)priority
  attachmentIds:(NSString*)attachmentIds
        context:(NSMutableDictionary*)context
       delegate:(id)delegate
{
    NSString *url = [[[Constant instance] rootPath] stringByAppendingFormat:ENTERPRISE_NEWTASK_URL];
    NSLog(@"【NewTask服务接口路径】%@", url);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:creatorWorkId forKey:@"creatorWorkId"];
    [params setObject:subject forKey:@"subject"];
    [params setObject:dueTime forKey:@"dueTime"];
    [params setObject:assigneeWorkId forKey:@"assigneeWorkId"];
    [params setObject:priority forKey:@"priority"];
    [params setObject:attachmentIds forKey:@"attachmentIds"];

    HttpWebRequest *httpRequest = [[HttpWebRequest alloc] init];
    ASIHTTPRequest *request = [httpRequest postAsync:url params:params headers:nil context:context delegate:delegate];
    [httpRequest release];
    return request;
}
- (ASIHTTPRequest*)createTaskAttach:(NSData*)attachmentData
                fileName:(NSString*)fileName
                    type:(NSString*)type
                 context:(NSMutableDictionary*)context
                delegate:(id)delegate
{
    NSString *url = [[[Constant instance] rootPath] stringByAppendingFormat:ENTERPRISE_CREATETASKATTACH_URL];
    NSLog(@"【CreateTaskAttach服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:fileName forKey:@"fileName"];
    [params setObject:type forKey:@"type"];
    
    HttpWebRequest *httpRequest = [[HttpWebRequest alloc] init];
    ASIHTTPRequest *request = [httpRequest postAsync:url params:params fileData:attachmentData fileKey:@"attachment" headers:nil context:context delegate:delegate];
    [httpRequest release];
    return request;
}
- (ASIHTTPRequest*)createTaskComment:(NSString*)weiboId
                   taskId:(NSString*)taskId
                   workId:(NSString*)workId
                  content:(NSString*)content
                  context:(NSMutableDictionary*)context
                 delegate:(id)delegate
{
    NSString *url = [[[Constant instance] rootPath] stringByAppendingFormat:ENTERPRISE_CREATETASKCOMMENT_URL];
    NSLog(@"【CreateTaskComment服务接口路径】%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:weiboId forKey:@"weiboId"];
    [params setObject:taskId forKey:@"taskId"];
    [params setObject:workId forKey:@"workId"];
    [params setObject:content forKey:@"content"];
    
    HttpWebRequest *httpRequest = [[HttpWebRequest alloc] init];
    ASIHTTPRequest *request = [httpRequest postAsync:url params:params headers:nil context:context delegate:delegate];
    [httpRequest release];
    return request;
}
- (ASIHTTPRequest*)findUsers:(NSString*)workId
              key:(NSString*)key
          context:(NSMutableDictionary*)context
         delegate:(id)delegate
{
    NSString *url = [[[Constant instance] rootPath] stringByAppendingFormat:ENTERPRISE_FINDUSERS_URL];
    NSLog(@"【FindUsers服务接口路径】%@", url);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:workId forKey:@"workId"];
    [params setObject:key forKey:@"key"];

    HttpWebRequest *httpRequest = [[HttpWebRequest alloc] init];
    ASIHTTPRequest *request = [httpRequest postAsync:url params:params headers:nil context:context delegate:delegate];
    [httpRequest release];
    return request;
}

@end
