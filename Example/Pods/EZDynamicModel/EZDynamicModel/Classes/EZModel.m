//
//  EZModel.m
//  EZCreateDynamicModel
//
//  Created by 卢天翊 on 2017/6/1.
//  Copyright © 2017年 Ezer. All rights reserved.
//

#import "EZModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation EZModel

+ (NSArray <EZModel *>*)modelWithArray:(NSArray <NSDictionary *> *)array {
    
    NSMutableArray * models = @[].mutableCopy;
    
    for (NSDictionary * dic in array) {
        
        [models addObject:[EZModel modelWithDictionary:dic]];
    }
    
    return models;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    
    id model = [self new];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [model setValue:obj forKey:key];
    }];
    
    return model;
}

- (id)valueForKey:(NSString *)key {
    
    SEL getterMethod = NSSelectorFromString(key);
    
    return ((id(*)(id, SEL, NSString *))objc_msgSend)(self, getterMethod, key);
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    @autoreleasepool {
        
        if (!class_getProperty(self.class, [key UTF8String])) {
            
            objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\""/* e.g. @"NSString" */, NSStringFromClass([value class])] UTF8String] }; // T = type
            objc_property_attribute_t ownershipOne = { "R", "" }; // C = copy
            objc_property_attribute_t ownershipTwo = { "N", "" }; // N = nonatomic
            objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"%@", key] UTF8String] };
            
            objc_property_attribute_t attrs[] = { type, ownershipOne, ownershipTwo, backingivar };
            
            if (class_addProperty(self.class, [key UTF8String], attrs, 3)) {
                
                NSString * _key = [NSString stringWithFormat:@"%@", key];
                
                IMP objectGetter = imp_implementationWithBlock(^ id (id blockSelf){
                    
                    return objc_getAssociatedObject(blockSelf, (__bridge void *)_key);
                });
                
                IMP objectSetter = imp_implementationWithBlock(^(id blockSelf, id value){
                    
                    objc_setAssociatedObject(blockSelf, (__bridge void *)_key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                });
                
                class_addMethod(self.class, NSSelectorFromString(key), objectGetter, "@@:");
                class_addMethod(self.class, NSSelectorFromString([NSString stringWithFormat:@"set%@:", [key capitalizedString]]), objectSetter, "v@:@");
            }
        }
        
        SEL setterMethod = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [key capitalizedString]]);
        
        ((void(*)(id, SEL, id, NSString *))objc_msgSend)(self, setterMethod, value, key);
    }
}

- (NSString *)description {
    
    unsigned int outCount;
    
    NSMutableString * description = @"<".mutableCopy;
    
    [description appendFormat:@"%@: %p;\n", NSStringFromClass(self.class), self];
    
    objc_property_t * propertyList = class_copyPropertyList(self.class, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        
        objc_property_t property = propertyList[i];
        
        NSString * objectName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [description appendFormat:@"\t%@: %@;\n", objectName, [self valueForKey:objectName]];
    }
    
    [description appendString:@">\n"];
    
    return description;
}

@end
