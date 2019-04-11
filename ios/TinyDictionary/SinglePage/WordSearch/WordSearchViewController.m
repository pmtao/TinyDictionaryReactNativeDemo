//
//  WordSearchViewController.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import "WordSearchViewController.h"
#import "ShowDefinition.h"
#import "SearchHistory.h"
#import "SimpleListTableViewController.h"
#import "PageCreator.h"
#import "TextTool.h"
#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>
#import "NavigationDelegate.h"

@interface WordSearchViewController ()

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UITextChecker *textChecker;
@property (strong, nonatomic) NSMutableArray *words;
@property (strong, nonatomic) NSMutableArray *ignoredWords;
@property (strong, nonatomic) ShowDefinition *showDefinition;
@property (strong, nonatomic) SearchHistory *searchHistory;
@property (strong, nonatomic) NavigationDelegate *navigationDelegate;

@end

@implementation WordSearchViewController {
    
    CGFloat searchBarNormalHeight;
    
}


@synthesize searchBar, showDefinition, searchHistory;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    suggestedWords = [NSMutableArray array];
    searchHistory = [SearchHistory new];
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
    searchBarNormalHeight = self.tableView.contentOffset.y;
    [super viewDidAppear:animated];
    if (![self.searchBar isFirstResponder]) {
        [self.searchBar becomeFirstResponder];
    } else {
        NSLog(@"searchBar is already first responder.");
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationDelegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self.ignoredWords removeAllObjects];
}

- (void)setup {
    suggestedWords = [NSMutableArray array];
    searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.spellCheckingType = UITextSpellCheckingTypeNo;
    searchBar.placeholder = @"请输入您要查询的单词";
    self.navigationItem.titleView = self.searchBar;
    [searchBar sizeToFit];
    
    
    self.textChecker = [[UITextChecker alloc] init];
    self.words = [[NSMutableArray alloc] init];
    self.ignoredWords = [NSMutableArray array];
    
    UIBarButtonItem *configBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"config"]
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(configButtonTapped:)];
    self.navigationItem.rightBarButtonItem = configBarButtonItem;
}

/// 自定义转场代理
- (void)setupNavigationDelegate {
    if (self.navigationDelegate == nil) {
        self.navigationDelegate = [[NavigationDelegate alloc] init:self.navigationController];
    }
}

#pragma mark - Search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self updateWords];
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchWord = searchBar.text;
    [searchBar resignFirstResponder];
    [self showDefinition:searchWord];
}

#pragma mark - scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.searchBar isFirstResponder]) {
        // 退出搜索框焦点
        [self.searchBar resignFirstResponder];
    } else {
        // 重新进入搜索框焦点
        if (searchBarNormalHeight > (scrollView.contentOffset.y + 40)) {
            [self.searchBar becomeFirstResponder];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.words count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.words objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    NSString *word = [self.words objectAtIndex:indexPath.row];
//    [self showDefinition:word];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSURL *jsCodeLocation;
#ifdef DEBUG
    //开发包
    jsCodeLocation = [NSURL URLWithString:@"http://192.168.1.132:8081/index.bundle?platform=ios"];
//    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
#else
    //离线包
    jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"bundle/index.ios" withExtension:@"jsbundle"];
#endif
    UIViewController *vc = [[UIViewController alloc] init];
    RCTRootView *rootView =
    [[RCTRootView alloc] initWithBundleURL: jsCodeLocation
                                moduleName: @"SlideCardsView"
                         initialProperties: @{@"term": word
                                              }
                             launchOptions: nil];
    
    vc.view = rootView;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Text checker

- (void)updateWords
{
    NSString *word = searchBar.text;
    
    if (word != nil && [word isEqualToString:@""] == NO ) {
        [self.words removeAllObjects];
        NSMutableArray *suggestions = [[NSMutableArray alloc] initWithArray:[TextTool getTypeSuggestionAfterText:word]];
        self.words = suggestions;
    } else {
        self.words = [searchHistory.searchedWords mutableCopy];
    }
    
}

- (void)trimWords
{        
    NSMutableArray *trimmedArray = [[NSMutableArray alloc] initWithArray:self.words];
    for (int i = 0; i<[trimmedArray count]; i++) {
        if (![UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:[trimmedArray objectAtIndex:i]]) {
            [self.ignoredWords addObject:[trimmedArray objectAtIndex:i]];
        }
    }
}

#pragma mark - 打开单词解释

- (void)showDefinition:(NSString *)word {
    showDefinition = [[ShowDefinition alloc] initWithWord:word];
    [self.navigationController pushViewController:showDefinition.cardsView animated:YES];
    if ([searchHistory.searchedWords containsObject:word] == NO) {
        [searchHistory.searchedWords addObject:word];
    }
}

#pragma mark - 打开设置页

- (void)configButtonTapped:(id)sender
{
    SimpleListTableViewController *appConfigVC = [PageCreator initialAppConfigViewController];
    UINavigationController *appConfigNavigationController = [[UINavigationController alloc] initWithRootViewController:appConfigVC];
    [self presentViewController:appConfigNavigationController animated:YES completion:nil];
}

@end
