//
//  ViewController.m
//  UIWebviewWithCookie
//  Created by Bzxy on 2019/11/9.
//  Copyright © 2019 Bzxy. All rights reserved.
//
//


#import "ViewController.h"
#define YourURL @"http://bzxy.xyz/repo/manage/login.php"//url域名地址
@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.frame =self.webView.frame;
    _webView.backgroundColor = [UIColor grayColor];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20)];
    _webView.delegate = self;
    //判断是否沙盒中是否有这个值
    if ([[[[NSUserDefaults standardUserDefaults]dictionaryRepresentation]allKeys]containsObject:@"cookie"]) {
        //获取cookies：程序起来之后，uiwebview加载url之前获取保存好的cookies，并设置cookies，
        NSArray *cookies =[[NSUserDefaults standardUserDefaults]  objectForKey:@"cookie"];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
        [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
    }
    //发请求
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://bzxy.xyz/repo/manage/login.php",YourURL]]];//url域名地址
    _webView.scalesPageToFit = YES;
    [ self.webView loadRequest:req];
    [self.view addSubview:self.webView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
// 将获取的cookie储存在沙盒中（ 通过 [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie: cookies]来保存cookies，但是我发现，即使这样设置之后再app退出之后，该cookies还是丢失了（其实是cookies过期的问题)
    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSHTTPCookie *cookie;
    for (id c in nCookies)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie=(NSHTTPCookie *)c;
            if ([cookie.name isEqualToString:@"PHPSESSID"]) {
                NSNumber *sessionOnly = [NSNumber numberWithBool:cookie.sessionOnly];
                NSNumber *isSecure = [NSNumber numberWithBool:cookie.isSecure];
                NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, sessionOnly, cookie.domain, cookie.path, isSecure, nil];
                [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:@"cookie"];
                break;
            }
        }
    }
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"--------------%@",error);
    - (void)viewDidLoad {
        [super viewDidLoad];
        
        UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:myWebview];
        
        NSURL *url = [NSURL URLWithString:@"www.baidu.com"];
        NSURLRequest *request =[NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:0.5];
        [webview loadRequest:request];
        
        
        if (theConnection)
        {
            [theConnection cancel];
            
            NSLog(@"safe release connection");
        }
        theConnection= [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    }
    
    -(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
    {
        if (theConnection) {
            
            NSLog(@"safe release connection");
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]){
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if ((([httpResponse statusCode]/100) == 2)){
                NSLog(@"connection ok");
            }
            else{
                NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:nil];
                if ([error code] == 404){
                    NSLog(@"404");
                    
                }
            }
        }
    }
    
    -(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
        
        if (theConnection) {
            
            NSLog(@"safe release connection");
        }
        
        if (error.code == 22) //The operation couldn’t be completed. Invalid argument
            
            NSLog(@"22");
        else if (error.code == -1001) //The request timed out.  webview code -999的时候会收到－1001，这里可以做一些超时时候所需要做的事情，一些提示什么的
            
            NSLog(@"-1001");
        else if (error.code == -1005) //The network connection was lost.
            
            NSLog(@"-1005");
        else if (error.code == -1009){
@end

