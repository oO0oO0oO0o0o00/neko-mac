//
//  CatSettings.m
//  Neko
//
//  Created by MeowCat on 2025/1/12.
//

#import "CatSettings.h"

NSString * const kTransparencyRadius = @"transparencyRadius";
NSString * const kCenterTransparency = @"centerTransparency";

@implementation CatSettings
+(instancetype)loadSettings {
    CatSettings *res = [CatSettings new];
    [res loadSettings];
    return res;
}

-(void)loadSettings {
    self.transparencyRadius = (int) [NSUserDefaults.standardUserDefaults integerForKey:kTransparencyRadius];
    self.centerTransparency = (int) [NSUserDefaults.standardUserDefaults integerForKey:kCenterTransparency];
}

-(void) save {
    [NSUserDefaults.standardUserDefaults setInteger:self.transparencyRadius
                                             forKey:kTransparencyRadius];
    [NSUserDefaults.standardUserDefaults setInteger:self.centerTransparency
                                             forKey:kCenterTransparency];
}
@end