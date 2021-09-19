import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate/*, NSObject, NSApplicationDelegate*/ {
//  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
//    return true
//  }

    override func applicationDidFinishLaunching(_ aNotification: Notification) {
//        HotkeySolution.register()
//
//        let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
//        let channel = FlutterMethodChannel.init(name: "samples.flutter.dev/battery", binaryMessenger: controller.engine.binaryMessenger)
//        channel.setMethodCallHandler({
//          (_ call: FlutterMethodCall, _ result: FlutterResult) -> Void in
//            print("hgoehogehogeogeoho")
//            NSWorkspace.shared.launchApplication("Google Chrome.app")
//        });
    }

    override func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
