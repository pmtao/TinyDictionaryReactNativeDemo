//
//  WordSearchViewController.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordSearchViewController : UITableViewController <UISearchBarDelegate>
{
    /** 建议查询的单词 */
    @package NSMutableArray *suggestedWords;
}
@end
