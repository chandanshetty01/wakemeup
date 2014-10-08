//
//  KKMailComposerManager.m
//  KachiKachi
//
//  Created by Chandan on 08/08/2013.
//  Copyright (c) 2014 Chanddan. All rights reserved.
//

#import "MailComposerManager.h"

@interface MailComposerManager()
@property(nonatomic,strong) completionBlkWithInteger completionBlk;
@end

@implementation MailComposerManager

+ (id) sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark - Compose Mail/SMS

// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an email composition interface inside the application.
//  Populates all the Mail fields.
// -------------------------------------------------------------------------------
- (void)displayMailComposerSheet:(UIViewController*)inController
                    toRecipients:(NSArray*)toRecipients
                    ccRecipients:(NSArray*)ccRecipients
                  attachmentData:(NSData*)attachmentData
              attachmentMimeType:(NSString*)attachmentMimeType
              attachmentFileName:(NSString*)attachmentFileName
                       emailBody:(NSString*)emailBody
                    emailSubject:(NSString*)emailSubject
                      completion:(completionBlkWithInteger)completionBlk
{
    self.completionBlk = completionBlk;
    if ([MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        [picker setSubject:emailSubject];
        
        // Set up recipients
        if(toRecipients)
            [picker setToRecipients:toRecipients];
        if(ccRecipients)
            [picker setCcRecipients:ccRecipients];
        
        if(attachmentData)
            [picker addAttachmentData:attachmentData mimeType:attachmentMimeType fileName:attachmentFileName];
        // Fill out the email body text
        [picker setMessageBody:emailBody isHTML:NO];
        
        [inController presentViewController:picker animated:YES completion:NULL];
    }
    else{
        [self displayComposerSheet];
    }
}

-(void)displayComposerSheet
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MAIL_ERROR_TITLE", nil)
                                                    message:NSLocalizedString(@"MAIL_NO_CONFIGURED", nil)
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//	mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:{
            if(self.completionBlk)
                self.completionBlk(1);
        }
			break;
		case MFMailComposeResultFailed:
			break;
		default:
			break;
	}
    
    self.completionBlk = nil;
	[controller dismissViewControllerAnimated:YES completion:NULL];
}


@end
