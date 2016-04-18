//
//  ViewController.h
//  NSStreamSocket
//
//  Created by tongle on 16/4/18.
//  Copyright © 2016年 tongle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#define PORT 9000
@interface ViewController : UIViewController<NSStreamDelegate>
{
    int flag;
}
@property (nonatomic,retain)NSInputStream * inputStream;
@property (nonatomic,retain)NSOutputStream * outputSream;


@end

