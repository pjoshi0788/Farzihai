#import <UIKit/UIKit.h>
#import "NSBundle+Simplify.h"

#define SIMBundleErrorDomain [NSString stringWithFormat:@"%@.errordomain", [[NSBundle frameworkBundle] bundleIdentifier]]

typedef enum {
    SIMBundleErrorCodeNoPathFoundError,
    SIMBundleErrorCodeNibNotFound

} SIMBundleErrorCode;

@implementation NSBundle (Simplify)

+(NSBundle *)frameworkBundle {
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"Simplify.bundle"];
        frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return frameworkBundle;
}

+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)extension {

    NSBundle * mainBundle = [NSBundle mainBundle];
    NSString * path = [mainBundle pathForResource:name ofType:extension];
    if (path) {
        return path;
    }
    
    // Otherwise try with other bundles
    NSBundle * bundle;
    
    for (NSString * bundlePath in [mainBundle pathsForResourcesOfType:@"bundle" inDirectory:nil]) {
        bundle = [NSBundle bundleWithPath:bundlePath];
        path = [bundle pathForResource:name ofType:extension];
        if (path) {
            return path;
        }
    }
    
    NSString *errorDescription = [NSString stringWithFormat:@"No path found for: %@ (.%@)", name, extension];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorDescription};

    NSError *error = [NSError errorWithDomain:SIMBundleErrorDomain code:SIMBundleErrorCodeNoPathFoundError userInfo:userInfo];

    NSLog(@"%@%@", SIMBundleErrorDomain, error);

    return nil;
}

+ (NSArray *)loadNibNamed:(NSString *)name owner:(id)owner options:(NSDictionary *)options {

    NSBundle * mainBundle = [NSBundle mainBundle];

    if ([mainBundle pathForResource:name ofType:@"nib"]) {

        return [mainBundle loadNibNamed:name owner:owner options:options];
    }
    
    NSBundle * bundle;
    for (NSString * bundlePath in [mainBundle pathsForResourcesOfType:@"bundle" inDirectory:nil]) {
        bundle = [NSBundle bundleWithPath:bundlePath];
        if ([bundle pathForResource:name ofType:@"nib"]) {

            return [bundle loadNibNamed:name owner:owner options:options];
        }
    }

    NSString *errorDescription = [NSString stringWithFormat:@"Couldn't load Nib named: %@", name];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorDescription};
    
    NSError *error = [NSError errorWithDomain:SIMBundleErrorDomain code:SIMBundleErrorCodeNoPathFoundError userInfo:userInfo];
    
    NSLog(@"%@%@", SIMBundleErrorDomain, error);

    return nil;
}

@end