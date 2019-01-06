//
//  NetworkArray.h
//  ChatDemo
//
//  Created by 党玉华 on 2019/1/6.
//  Copyright © 2019年 dyh绝地求生专业送快递. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkArray : NSObject

/**
 *  获取所有有效的对象
 */
@property (nonatomic, strong, readonly)NSArray *allObjects;
/**
 *  添加对象
 *
 *  @param object 被添加对象
 */
- (void)addObject:(id)object;

@end
