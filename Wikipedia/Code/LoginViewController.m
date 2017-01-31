#import "LoginViewController.h"
#import "NSHTTPCookieStorage+WMFCloneCookie.h"
#import "AccountCreationViewController.h"
#import "CreateAccountFunnel.h"
#import "PreviewAndSaveViewController.h"
#import "SectionEditorViewController.h"
#import "AccountCreationViewController.h"
#import "UIBarButtonItem+WMFButtonConvenience.h"
#import "UIViewController+WMFStoryboardUtilities.h"
#import "Wikipedia-Swift.h"
#import "AFHTTPSessionManager+WMFCancelAll.h"
#import "MWKLanguageLinkController.h"
#import "WMFAuthenticationManager.h"
@import BlocksKitUIKitExtensions;

@interface LoginViewController () {
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *createAccountButton;
@property (weak, nonatomic) IBOutlet UILabel *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameUnderlineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordUnderlineHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *loginContainerView;
@property (strong, nonatomic) UIBarButtonItem *doneButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self)
        UIBarButtonItem *xButton = [UIBarButtonItem wmf_buttonType:WMFButtonTypeX
                                                           handler:^(id sender) {
                                                               @strongify(self)
                                                                   [self dismissViewControllerAnimated:YES
                                                                                            completion:nil];
                                                           }];
    self.navigationItem.leftBarButtonItems = @[xButton];

    self.doneButton = [[UIBarButtonItem alloc] bk_initWithTitle:MWLocalizedString(@"main-menu-account-login", nil)
                                                          style:UIBarButtonItemStylePlain
                                                        handler:^(id sender) {
                                                            @strongify(self)
                                                                [self save];
                                                        }];
    self.navigationItem.rightBarButtonItem = self.doneButton;

    self.titleLabel.font = [UIFont boldSystemFontOfSize:23.0f];
    self.usernameField.font = [UIFont boldSystemFontOfSize:18.0f];
    self.passwordField.font = [UIFont boldSystemFontOfSize:18.0f];
    self.createAccountButton.font = [UIFont boldSystemFontOfSize:14.0f];

    self.createAccountButton.textColor = [UIColor wmf_blueTintColor];
    self.createAccountButton.text = MWLocalizedString(@"login-account-creation", nil);
    self.createAccountButton.userInteractionEnabled = YES;
    [self.createAccountButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createAccountButtonPushed:)]];

    self.forgotPasswordButton.text = MWLocalizedString(@"login-forgot-password", nil);
    self.forgotPasswordButton.textColor = [UIColor wmf_blueTintColor];
    self.forgotPasswordButton.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.forgotPasswordButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPasswordButtonPushed:)]];
    
    self.usernameField.attributedPlaceholder =
        [self getAttributedPlaceholderForString:MWLocalizedString(@"login-username-placeholder-text", nil)];
    self.passwordField.attributedPlaceholder =
        [self getAttributedPlaceholderForString:MWLocalizedString(@"login-password-placeholder-text", nil)];

    if ([self.scrollView respondsToSelector:@selector(keyboardDismissMode)]) {
        self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }

    [self.usernameField addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];

    [self.passwordField addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];

    self.usernameUnderlineHeight.constant = 1.0f / [UIScreen mainScreen].scale;
    self.passwordUnderlineHeight.constant = self.usernameUnderlineHeight.constant;

    self.titleLabel.text = MWLocalizedString(@"navbar-title-mode-login", nil);

    self.usernameField.textAlignment = NSTextAlignmentNatural;
    self.passwordField.textAlignment = NSTextAlignmentNatural;
}

- (NSAttributedString *)getAttributedPlaceholderForString:(NSString *)string {
    return [[NSMutableAttributedString alloc] initWithString:string
                                                  attributes:@{
                                                      NSForegroundColorAttributeName: [UIColor lightGrayColor]
                                                  }];
}

- (void)textFieldDidChange:(id)sender {
    BOOL shouldHighlight = ((self.usernameField.text.length > 0) && (self.passwordField.text.length > 0)) ? YES : NO;
    [self enableProgressiveButton:shouldHighlight];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self save];
    }
    return YES;
}

- (void)enableProgressiveButton:(BOOL)highlight {
    self.doneButton.enabled = highlight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self enableProgressiveButton:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.usernameField becomeFirstResponder];
}

- (void)save {
    [self enableProgressiveButton:NO];
    [[WMFAlertManager sharedInstance] dismissAlert];

    [[WMFAuthenticationManager sharedInstance] loginWithUsername:self.usernameField.text
        password:self.passwordField.text
        success:^{
            NSString *loggedInMessage = MWLocalizedString(@"main-menu-account-title-logged-in", nil);
            loggedInMessage = [loggedInMessage stringByReplacingOccurrencesOfString:@"$1"
                                                                         withString:self.usernameField.text];
            [[WMFAlertManager sharedInstance] showAlert:loggedInMessage sticky:NO dismissPreviousAlerts:YES tapCallBack:NULL];

            [self dismissViewControllerAnimated:YES completion:nil];
            [self.funnel logSuccess];
        }
        failure:^(NSError *error) {
            [self enableProgressiveButton:YES];
            [[WMFAlertManager sharedInstance] showErrorAlert:error sticky:YES dismissPreviousAlerts:YES tapCallBack:NULL];
            [self.funnel logError:error.localizedDescription];
        }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self enableProgressiveButton:NO];
    [super viewWillDisappear:animated];
}

- (void)forgotPasswordButtonPushed:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        UIViewController *presenter = self.presentingViewController;
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     ForgotPasswordViewController *forgotPasswordVC = [ForgotPasswordViewController wmf_viewControllerFromStoryboardNamed:@"ForgotPasswordViewController"];
                                     //ForgotPasswordViewController *forgotPasswordVC = [ForgotPasswordViewController wmf_initialViewControllerFromClassStoryboard];
                                     UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:forgotPasswordVC];
                                     [presenter presentViewController:nc animated:YES completion:nil];
                                 }];
    }
}

- (void)createAccountButtonPushed:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.funnel logCreateAccountAttempt];

        UIViewController *presenter = self.presentingViewController;
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     AccountCreationViewController *createAcctVC = [AccountCreationViewController wmf_initialViewControllerFromClassStoryboard];

                                     createAcctVC.funnel = [[CreateAccountFunnel alloc] init];
                                     [createAcctVC.funnel logStartFromLogin:self.funnel.loginSessionToken];

                                     UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:createAcctVC];

                                     [presenter presentViewController:nc animated:YES completion:nil];
                                 }];
    }
}

@end
