import Cocoa
import FlutterMacOS
import Sparkle

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    
    override func applicationDidFinishLaunching(_ aNotification: Notification) {
        let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
        let channel = FlutterMethodChannel.init(name: "switch.soul.monarch/channel", binaryMessenger: controller.engine.binaryMessenger)
        channel.setMethodCallHandler({
            (_ call: FlutterMethodCall, _ result: FlutterResult) -> Void in
            switch (call.method) {
            case "getApp":
                let args = call.arguments as! Dictionary<String, Any>
                let name = args["appPath"] as! String
                let url = URL(fileURLWithPath: name)
                let res = NSWorkspace.shared.icon(forFile: url.path)
                let image = res
                let cgimage = image.toCGImage
                
                result([
                    "image": FlutterStandardTypedData(bytes: cgimage.png!),
                    "path": url.absoluteString
                ])
                
                break;
            case "launch":
                let args = call.arguments as! Dictionary<String, Any>
                let name = args["path"] as! String
                NSWorkspace.shared.launchApplication(name)
                break;

            case "checkForUpdate":
                let updater = SUUpdater()
                updater.checkForUpdates(self)

                // TODO SUUUpdater is depricated. use SPUUpdater
//                let userDriver: SPUUserDriver = SPUStandardUserDriver(hostBundle: Bundle.main, delegate: nil)
//                let updater = SPUUpdater(hostBundle: Bundle.main, applicationBundle: Bundle.main, userDriver: userDriver, delegate: nil)
//                do {
//                    try updater.start()
//                    updater.checkForUpdates()
//                } catch {
//                    assertionFailure("Failed to initalize updater: \(error)")
//                }

                break;

            case "terminate":
                NSApplication.shared.terminate(nil)
                break;

            default:
                break;
            }
        });
    }
    
    override func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

extension NSImage {
    var toCGImage: CGImage {
        var imageRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        #if swift(>=3.0)
        guard let image =  cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
            abort()
        }
        #else
        guard let image = CGImageForProposedRect(&imageRect, context: nil, hints: nil) else {
            abort()
        }
        #endif
        return image
    }
}

extension CGImage {
    var png: Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
              let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}
