#import <UIKit/UIKit.h>

#define VALID_KEY "MY-KEY-2026"

__attribute__((constructor))
static void initializeKeySystem() {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isActivated = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsAppLicensed"];
        if (isActivated) return;

        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (!rootVC) return;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ระบบยืนยันตัวตน"
                                                                       message:@"กรุณากรอก Key เพื่อเข้าใช้งาน"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"ใส่คีย์ที่นี่";
        }];

        UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *keyField = alert.textFields.firstObject;
            if ([keyField.text isEqualToString:@VALID_KEY]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsAppLicensed"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                exit(0);
            }
        }];

        [alert addAction:submitAction];
        [rootVC presentViewController:alert animated:YES completion:nil];
    });
}
