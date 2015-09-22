@interface NSBundle (Simplify)

/**
 Bundles the framework for Simplify
 @return a bundled version of the Simplify Merchant SDK
 */
+ (NSBundle *)frameworkBundle;
+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)extension;
+ (NSArray *)loadNibNamed:(NSString *)name owner:(id)owner options:(NSDictionary *)options;

@end
