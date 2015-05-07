//
//  FileManager.m
//  Core
//
//  Created by sheely on 13-9-25.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (void)writeFile:(NSString*)file  data:(NSData *)data
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/"];;//去处需要的路径

    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    //获取文件路径
    //[fileManager removeItemAtPath:@"username"error:nil];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:file];
    SHLog(@"path=%@",path);
    //创建数据缓冲
    NSFileHandle  *outFile;
    outFile = [NSFileHandle fileHandleForWritingAtPath:path];
    if(outFile == nil)
    {
        NSLog(@"Open of file for writing failed");
        NSString *s = [NSString stringWithFormat:@""];
        [s writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }

     outFile = [NSFileHandle fileHandleForWritingAtPath:path];
        [outFile seekToEndOfFile];
    [outFile writeData:data];
    [outFile closeFile];
}
/******文件读取******/
+ (NSString *)readFile:(NSString*)file
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/"];;//去处需要的路径
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    //获取文件路径
    NSString *path = [documentsDirectory stringByAppendingPathComponent:file];
    NSData *reader = [NSData dataWithContentsOfFile:path];
    return [[NSString alloc] initWithData:reader
                                 encoding:NSUTF8StringEncoding];
}

+ (BOOL)deleteFile :(NSString*) file
{
    NSFileManager* fileManager=[NSFileManager defaultManager];

    
    //文件名
    NSString *uniquePath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/"]stringByAppendingPathComponent:file];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return NO;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
            return YES;
        }else {
            NSLog(@"dele fail");
            return NO;
        }
        
    }
}

@end
