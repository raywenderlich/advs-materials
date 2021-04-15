/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

#import "FeedCell.h"
#import "BabyTrack-Swift.h"

@interface FeedCell ()
@property (nonatomic, strong) IBOutlet UILabel *lblKindEmoji;
@property (nonatomic, strong) IBOutlet UILabel *lblKindTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIImageView *attachment;
@end

@implementation FeedCell

- (void)configureWithFeedItem:(FeedItem *)feedItem {
  self.lblKindEmoji.text = [FeedItem emojiForKind:feedItem.kind];
  self.lblKindEmoji.backgroundColor = [FeedItem colorForKind:feedItem.kind];
  self.lblKindTitle.text = [FeedItem titleForKind:feedItem.kind];

  NSRelativeDateTimeFormatter *df = [NSRelativeDateTimeFormatter new];
  df.formattingContext = NSFormattingContextStandalone;
  self.lblDate.text = [df stringForObjectValue:feedItem.date];
  
  [self.attachment setHidden: feedItem.attachmentId == nil];
  
  [[NSURLSession.sharedSession dataTaskWithURL:feedItem.attachmentURL
                             completionHandler:^(NSData * _Nullable data,
                                                 NSURLResponse * _Nullable response,
                                                 NSError * _Nullable error) {

    __weak FeedCell *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      weakSelf.attachment.image = [UIImage imageWithData:data];
    });
  }] resume];
}

@end