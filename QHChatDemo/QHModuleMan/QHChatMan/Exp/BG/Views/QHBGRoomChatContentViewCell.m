//
//  QHBGRoomChatContentViewCell.m
//  QHChatDemo
//
//  Created by Anakin chen on 2019/12/8.
//  Copyright © 2019 Chen Network Technology. All rights reserved.
//

#import "QHBGRoomChatContentViewCell.h"

#import "QHViewUtil.h"

@implementation QHBGRoomChatContentViewCell

- (void)p_addContentView {
    self.contentV = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentV];
    [QHViewUtil fullScreen:self.contentV edgeInsets:UIEdgeInsetsMake(TKQHCHAT_LC_CONTENT_EDGEINSETS.top, TKQHCHAT_LC_CONTENT_EDGEINSETS.left, TKQHCHAT_LC_CONTENT_EDGEINSETS.bottom, TKQHCHAT_LC_CONTENT_EDGEINSETS.right)];
    
    /*
     例子资源中有两张图片，分别为 ggg.png & ggg@3x.png，如果使用 [UIImage imageWithContentsOfFile:path] & [UIImage imageNamed:path] 来加载图片的话，其 scale 会根据 @3x 来控制，而使用 [UIImage imageWithData:data] 则会忽略，需要自己控制 scale 的 [UIImage imageWithData:data scale:scale] 来创建。
     
     scale
     > 是比例因子，会影响 size 的值。1.0时，图片的 size 和像素尺寸相等。2.0时，size 是像素尺寸的一半。屏幕大小不变，分辨率越高，显示的图片越小。
     
     为什么需要根据图片控制 scale 的原因？因为需要控制背景图的高度与公屏的一行高度接近，这样才能不变形。如果单纯通过压缩分辨率，来缩小 size，会导致图标变模糊，因此通过 scale 才能缩小size，同时不会影响分辨率。
     
     想看效果的话可以切换图片看。
     
     而在该 ChatMan 上使用的 UITableView 是本地计算高度，只会出现变形。但是使用 UITableViewAutomaticDimension 的话，且 背景图片size 大于一行，则会撑大整个 Cell。
     
     建议如果使用 Data 或者 不包含 @3x 的方式加载，添加计算 scale 来使用，代码如下：
     
     ~~~
     int scale = (int)roundf(oImage.size.height / 20.0);
     ~~~
     
     参考：
     * [UIImage](https://www.jianshu.com/p/e9aa48155c11)
     */
    
    // 添加背景图片
    UIImageView *bgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ggg@3x.png" ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    // 拉伸图片的区域
    UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, image.size.height - 1, image.size.width - 1);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    bgV.image = image;
    [self.contentView addSubview:bgV];
    [QHViewUtil fullScreen:bgV edgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
    
}

@end
