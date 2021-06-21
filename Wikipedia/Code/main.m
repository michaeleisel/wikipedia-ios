#import "AppDelegate.h"
#import "Wikipedia-Swift.h"
#import <mach-o/dyld.h>

#if TEST

/**
 *  Mock application delegate for use in unit testing. This is used for 2 reasons:
 *
 *  1. Visual tests require that the application has a @c keyWindow, and we don't pass the regular application delegate to
 *  prevent unintended side effects from regular application code when testing.
 *
 *  2. Stubbed networking tests can fail if unexpected network operations are triggered by the application.
 */
@interface WMFMockAppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation  WMFMockAppDelegate

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
#endif
void yoo2();
void yoo3();
void yoo4();
void yoo5();
void yoo6();
void yoo7();
void yoo8();
void yoo9();
void yoo10();
void yoo11();
void yoo12();
void yoo13();
void yoo14();
void yoo15();
void yoo16();
void yoo17();
void yoo18();
void asdlfjasd();
void yoo19();
int main(int argc, char *argv[]) {
    if (!strstr(_dyld_get_image_name(0), "/Wikipedia")) { abort(); }
    intptr_t slide = _dyld_get_image_vmaddr_slide(0);
    printf("image: %p\n", _dyld_get_image_header(0));
    printf("slide: %lu\n", slide);

     yoo2();
     yoo3();
    asdlfjasd();
     yoo4();
     yoo5();
     yoo6();
     yoo8();
     yoo9();
     yoo12();
     yoo13();
     yoo16();
     yoo17();
     yoo18();
    @autoreleasepool {
        WMFSwiftKVOCrashWorkaround *workarounder = [[WMFSwiftKVOCrashWorkaround alloc] init];
        [workarounder performWorkaround];
        NSString *delegateClass = NSStringFromClass([AppDelegate class]);
#if TEST
        // disable app when unit testing to allow tests to run in isolation (w/o side effects)
        if (NSClassFromString(@"XCTestCase") != nil) {
            delegateClass = NSStringFromClass([WMFMockAppDelegate class]);
        }
#endif
            return UIApplicationMain(argc, argv, nil, delegateClass);
    }
}

//#import "CLRCallRecorder.h"
#import <dlfcn.h>
#import <libkern/OSAtomicQueue.h>
#import <pthread.h>
#import <mach-o/dyld.h>

typedef struct {
    void *ptr;
    NSInteger number;
} CLRCall;

static OSQueueHead sQueueData = OS_ATOMIC_QUEUE_INIT;
static OSQueueHead *sQueue = &sQueueData;
static BOOL sStopCollecting = NO;
static BOOL sInitDidOccur = NO;

typedef struct {
    void *pointer;
    void *next;
} PointerNode;

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start, uint32_t *stop) {
    sInitDidOccur = YES;
    for (uint32_t *x = start; x < stop; x++) {
        *x = 1;
    }
}

void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
    // If initialization has not occurred yet (meaning that guard is uninitialized), that means that initial functions like +load are being run. These functions will only be run once anyways, so we should always allow them to be recorded and ignore guard
    if (sStopCollecting || (!(*guard) && sInitDidOccur)) {
        return;
    }
    *guard = 0;
    void *pointer = __builtin_return_address(0);
    PointerNode *node = malloc(sizeof(PointerNode));
    *node = (PointerNode){pointer, NULL};
    OSAtomicEnqueue(sQueue, node, offsetof(PointerNode, next));
}

extern NSArray <NSNumber *> *CLRCollectCalls(void) {
    sStopCollecting = YES;
    __sync_synchronize();
    // Hopefully, any other threads for which sStopCollecting was NO when they entered and are still preempted will get to preempt
    // during this sleep and finish up
    sleep(1);
    NSMutableArray <NSNumber *> *functions = [NSMutableArray array];
    while (YES) {
        PointerNode *node = OSAtomicDequeue(sQueue, offsetof(PointerNode, next));
        if (node == NULL) {
            break;
        }
        [functions addObject:@((NSUInteger)node->pointer)];
    }
    return [[functions reverseObjectEnumerator] allObjects];
}

void finishh() {
    if (!strstr(_dyld_get_image_name(0), "/Wikipedia")) {
        abort();
    }
    intptr_t slide = _dyld_get_image_vmaddr_slide(0);
    NSArray <NSNumber *> *calls = CLRCollectCalls();
    printf("-- begin calls\n");
    for (NSNumber *call in calls) {
        printf("zzzz %zu\n", [call unsignedIntegerValue] - slide);
    }
    printf("-- end calls\n");
}
