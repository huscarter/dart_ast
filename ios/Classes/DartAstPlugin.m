#import "DartAstPlugin.h"
#if __has_include(<dart_ast/dart_ast-Swift.h>)
#import <dart_ast/dart_ast-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dart_ast-Swift.h"
#endif

@implementation DartAstPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDartAstPlugin registerWithRegistrar:registrar];
}
@end
