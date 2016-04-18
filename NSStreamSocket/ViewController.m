//
//  ViewController.m
//  NSStreamSocket
//
//  Created by tongle on 16/4/18.
//  Copyright © 2016年 tongle. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)sendData:(id)sender;
- (IBAction)receiveData:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *message;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initNetworkCommunication
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"172.16.4.26", PORT, &readStream, &writeStream);
    
    _inputStream = (__bridge_transfer NSInputStream *)readStream;
    _outputSream = (__bridge_transfer NSOutputStream *)writeStream;
    [_inputStream setDelegate:self];
    [_outputSream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputSream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputSream open];
}

- (IBAction)sendData:(id)sender {
    flag = 0;
    [self initNetworkCommunication];
}

- (IBAction)receiveData:(id)sender {
    flag = 1;
    [self initNetworkCommunication];
}
-(void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEven{
    NSString * event;
    switch (streamEven) {
        case NSStreamEventNone:
            event = @"NSStreamEventNone";
            break;
            case NSStreamEventOpenCompleted:
            event = @"NSStreamEventOpenCompleted";
            break;
            case NSStreamEventHasBytesAvailable:
            event = @"NSStreamEventHasBytesAvailable";
            if (flag == 1 && theStream == _inputStream) {
                NSMutableData *input = [[NSMutableData alloc]init];
                uint8_t buffer[1024];
                NSInteger len;
                while ([_inputStream hasBytesAvailable]) {
                    len = [_inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len>0) {
                        [input appendBytes:buffer length:len];
                    }
                }
                NSString * resultstring = [[NSString alloc]initWithData:input encoding:NSUTF8StringEncoding];
                NSLog(@"接受 ：%@",resultstring);
                _message.text = resultstring;
            }
            break;
            case NSStreamEventHasSpaceAvailable:
            event = @"NSStreamEventHasSpaceAvailable";
            if (flag == 0 && theStream == _outputSream) {
                uint8_t buff[] = "Hello Server";
                [_outputSream write:buff maxLength:strlen((const char *)buff) +1];
                [_outputSream close];
            }
             break;
            case NSStreamEventErrorOccurred:
            event = @"NSStreamEventErrorOccurred";
            [self close];
            break;
            case NSStreamEventEndEncountered:
            event = @"NSStreamEventEndEncountered";
            break;
            
        default:
            [self close];
            event = @"Unknown";
            break;
    }
    NSLog(@"even----%@",event);
}
-(void)close
{
    [_outputSream close];
    [_outputSream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputSream setDelegate:nil];
    [_inputStream close];
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream setDelegate:nil];
    
}



@end
