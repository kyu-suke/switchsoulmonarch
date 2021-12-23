import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    
    override func applicationDidFinishLaunching(_ aNotification: Notification) {
        let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
        let channel = FlutterMethodChannel.init(name: "samples.flutter.dev/hoge", binaryMessenger: controller.engine.binaryMessenger)
        channel.setMethodCallHandler({
            (_ call: FlutterMethodCall, _ result: FlutterResult) -> Void in
            switch (call.method) {
            case "getBatteryLevel":
                let args = call.arguments as! Dictionary<String, Any>
                let name = args["hoge"] as! String
                let url = URL(fileURLWithPath: name)
                print(url)
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
