//
//  NetworkArray.m
//  ChatDemo
//
//  Created by 党玉华 on 2019/1/6.
//  Copyright © 2019年 dyh绝地求生专业送快递. All rights reserved.
//

#import "NetworkArray.h"

@interface NetworkArray ()

@property (nonatomic,strong)NSPointerArray * pointerArray;

@end

@implementation NetworkArray

- (instancetype)init{
    self = [super init];
    if (self) {
        _pointerArray = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}
//出现这种 bug 的原因，和 compact 函数的实现机制有关，当我们主动给 NSPointerArray 添加 NULL 时，数组会标记有空元素插入，此时 compact 函数才会生效，也就是说，compact 函数会先判断是否有标记，之后才会剔除。所以，当直接 set count，或者成员已经释放，自动置空的情况出现时，就会出现这个 bug。解决也很简单：在调用 compact 之前，手动添加一个 NULL，触发标记
- (void)addObject:(id)object {
    [self.pointerArray addPointer:NULL];//必须要有，否则compact是不会生效的
    [self.pointerArray compact];//消除空指针
    [self.pointerArray addPointer:(__bridge void *)(object)];
}
#pragma mark - 重写getter方法
- (NSArray *)allObjects {
    return self.pointerArray.allObjects;
}

@end
