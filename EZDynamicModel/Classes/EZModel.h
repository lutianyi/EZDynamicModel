//
//  EZModel.h
//  EZCreateDynamicModel
//
//  Created by 卢天翊 on 2017/6/1.
//  Copyright © 2017年 Ezer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZModel : NSObject

/**
 使用字典数组转换成模型数组
 
 @param array 字典数组
 @return 模型数组
 */
+ (nonnull NSArray <__kindof EZModel*> *)modelWithArray:(nonnull NSArray <NSDictionary *> *)array;

/**
 使用字典转换成模型
 
 @param dictionary 字典
 @return 模型
 */
+ (nonnull instancetype)modelWithDictionary:(nonnull NSDictionary *)dictionary;


/**
 使用字典为模型赋值
 
 @param dictionary 要赋值的字典
 */
- (void)assignWithDictionary:(nonnull NSDictionary *)dictionary;

/**
 使用另一个模型赋值
 
 @param model 其他模型
 */
- (void)assignWithOtherModel:(nonnull id)model;

/**
 使用属性名取出对应的值
 
 @param key 属性名
 @return 属性值
 */
- (nullable id)valueForKey:(NSString *_Nonnull)key;

/**
 对某个属性单独赋值, 如果没有该属性会自动创建该属性并赋值
 
 @param value 属性值
 @param key 属性名
 */
- (void)setValue:(nullable id)value forKey:(NSString * _Nonnull)key;


/**
 获取所有的属性
 
 @return 以字典的形式返回所有已创建的属性和值
 */
- (nullable NSDictionary *)getAllPropertys;

@end
