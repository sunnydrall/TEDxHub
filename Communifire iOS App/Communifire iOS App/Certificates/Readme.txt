File: Communifire.iOS.App.Certificate_Development.p12
Detail: Certificate file for Development. To be used at Assets\Uploaded-CMS-Files\Certificates in CF APP.
When this certificate is used the first argument in ApplePushChannelSettings constructor should be false at following line:
push.RegisterAppleService(new ApplePushChannelSettings(false, appleCert, null, true));
Method: public static void SendiOSPushNotifications(int userID, string text, string url)

File: Communifire.iOS.App.Certificate.p12
Detail: Certificate file for Production. To be used at Assets\Uploaded-CMS-Files\Certificates in CF APP.
When this certificate is used the first argument in ApplePushChannelSettings constructor should be true at following line:
push.RegisterAppleService(new ApplePushChannelSettings(true, appleCert, null, true));
Method: public static void SendiOSPushNotifications(int userID, string text, string url)

Xcode specific files: 

File: aps_development.cer
Detail: APNS Certificate file for Development

File: aps.cer
Detail: APNS Certificate file for Production

File: ios_development.cer
Detail: Certificate file for Development. Used for running app via xcode to iOS devices.

File: CertificateSigningRequest.certSigningRequest
Detail: Local machine certification signing request to generate certificates on https://developer.apple.com/membercenter/index.action

File: Communifire_App_Development_Profile.mobileprovision
Detail: Provision Profile for xcode


