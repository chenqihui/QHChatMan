//
//  QHTKRoomChatVIewUtil+Gif.m
//  QHChatExampleDemo
//
//  Created by qihuichen on 2024/1/8.
//

#import "QHTKRoomChatVIewUtil+Gif.h"

#import <QHChatMan/QHChatMan.h>
#import <YYText/YYText.h>
#import "YYImage.h"

#import "TFHpple.h"
#import "QHGifTextAttachment.h"
#import "QHChatLiveCloudTFHppleUtil.h"

@implementation QHTKRoomChatVIewUtil (Gif)

+ (NSMutableAttributedString *)toChatGif:(NSDictionary *)data {
    NSDictionary *body = data[@"body"];
    NSString *n = body[@"n"];
    NSString *c = body[@"c"];
    CGFloat w = 20;
    NSString *contentString = [NSString stringWithFormat:@"<font color='#999999'>%@：</font><font color='#999999'>%@ </font><font t='gif' src='http://www.png' w='%f' name=''/><font color='#999999'> 哈喽</font>", n, c, w];
    NSMutableAttributedString *chatData = [NSMutableAttributedString new];
    [self anaylzeHtml:&chatData content:contentString];
    
    return chatData;
}


#pragma mark - Util

+ (void)anaylzeHtml:(NSMutableAttributedString **)chatData content:(NSString *)contentString {
    NSData *data = [contentString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//font"];
    for (TFHppleElement *element in elements) {
        NSString *type = element.attributes[@"t"];
        if (type != nil && [type isEqualToString:@"img"]) {
            NSString *url = element.attributes[@"src"];
            if (url != nil) {
                UIImage *i = [QHTKRoomChatVIewUtil download:url];
                if (i != nil) {
                    CGFloat w = [element.attributes[@"w"] floatValue];
                    [*chatData appendAttributedString:[QHChatBaseUtil toImage:i size:CGSizeMake(w, w) offBottom:-4]];
                }
            }
        }
        else if (type != nil && [type isEqualToString:@"gif"]) {
            CGFloat w = [element.attributes[@"w"] floatValue];
            QHGifTextAttachment *attachment = [QHGifTextAttachment new];
            attachment.gifName = @"[vip_来一首]";
            attachment.gifWidth = w;
            attachment.bounds = CGRectMake(0, 0, w, 0);
            attachment.image = nil;
            NSAttributedString *a = [NSAttributedString attributedStringWithAttachment:attachment];
            [*chatData appendAttributedString:a];
        }
        else if (type != nil && [type isEqualToString:@"gif2"]) {
            {
                NSURL *gifImageUrl = [[NSBundle mainBundle] URLForResource:@"[vip_来一首]" withExtension:@"gif"];
                NSData *data = [NSData dataWithContentsOfURL:gifImageUrl];
                YYImage *image = [YYImage imageWithData:data];
                CGSize size = image.size;
                CGFloat imageHeight = 18.5;
                if (imageHeight > 0) {
                    CGFloat h = imageHeight;
                    CGFloat w = image.size.width * h / image.size.height;
                    size = CGSizeMake(w, h);
                }
                UIFont *font = [UIFont systemFontOfSize:14];
                
                image.preloadAllAnimatedImageFrames = YES;
                YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                imageView.frame = CGRectMake(0, 0, size.width, size.height);
                imageView.autoPlayAnimatedImage = YES;
//                [imageView startAnimating];
                
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:size alignToFont:font alignment:YYTextVerticalAlignmentBottom];
                [*chatData appendAttributedString:attachText];
            }
            {
                NSURL *gifImageUrl = [[NSBundle mainBundle] URLForResource:@"vip_来一首" withExtension:@"png"];
                NSData *data = [NSData dataWithContentsOfURL:gifImageUrl];
                UIImage *image = [UIImage imageWithData:data];
                CGSize size = image.size;
                CGFloat imageHeight = 18.5;
                if (imageHeight > 0) {
                    CGFloat h = imageHeight;
                    CGFloat w = image.size.width * h / image.size.height;
                    size = CGSizeMake(w, h);
                }
                UIFont *font = [UIFont systemFontOfSize:14];
                NSMutableAttributedString *attachmentString = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFill attachmentSize:size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                attachmentString.yy_font = font;
                [*chatData appendAttributedString:attachmentString];
            }
        }
        else {
            NSString *color = element.attributes[@"color"];
            if (color == nil) {
                color = @"#FFFFFF";
            }
            NSAttributedString *a = [QHChatBaseUtil toContent:element.text color:[UIColor qh_colorWithHexString:color]];
            if (a != nil) {
                [*chatData appendAttributedString:a];
            }
        }
    }
}

+ (UIImage *)download:(NSString *)url {
    NSString *p = [[NSBundle mainBundle] pathForResource:@"vip_来一首" ofType:@"png"];
    UIImage *i = [UIImage imageWithContentsOfFile:p];
    return i;
}

+ (UIImageView *)gif:(NSString *)name {
    NSURL *gifImageUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@"gif"];
    NSData *data = [NSData dataWithContentsOfURL:gifImageUrl];
    NSTimeInterval duration = [self durationForGifData:data];
    //获取Gif图的原数据
//    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)gifImageUrl, NULL);
    CGImageSourceRef gifSource = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    size_t gifcount = CGImageSourceGetCount(gifSource);

    NSMutableArray *images = [[NSMutableArray alloc] init];

    for (NSInteger i = 0; i < gifcount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [images addObject:image];
        CGImageRelease(imageRef);
    }
    
    UIImageView *iv = [UIImageView new];
    iv.animationImages = images;
    iv.animationDuration = duration;
    
    return iv;
}

+ (NSTimeInterval)durationForGifData:(NSData *)data {
    char graphicControlExtensionStartBytes[] = {0x21,0xF9,0x04};
    double duration = 0;
    NSRange dataSearchLeftRange = NSMakeRange(0, data.length);
    while (YES) {
        NSRange frameDescriptorRange = [data rangeOfData:[NSData dataWithBytes:graphicControlExtensionStartBytes length:3]
                                                 options:NSDataSearchBackwards
                                                   range:dataSearchLeftRange];
        if (frameDescriptorRange.location != NSNotFound) {
            NSData *durationData = [data subdataWithRange:NSMakeRange(frameDescriptorRange.location + 4, 2)];
            unsigned char buffer[2];
            [durationData getBytes:buffer length:2];
            double delay = (buffer[0] | buffer[1] << 8);
            duration += delay;
            dataSearchLeftRange = NSMakeRange(0, frameDescriptorRange.location);
        }
        else {
            break;
        }
    }
    return duration/100;
}

@end
