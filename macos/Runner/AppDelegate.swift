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



        let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
        let channel = FlutterMethodChannel.init(name: "samples.flutter.dev/hoge", binaryMessenger: controller.engine.binaryMessenger)
        channel.setMethodCallHandler({
            (_ call: FlutterMethodCall, _ result: FlutterResult) -> Void in
            print("hgoehogehogeogeoho")
            
            let args = call.arguments as! Dictionary<String, Any>
            let name = args["hoge"] as! String
            print("=======================")
            print(name)
            print("-------------------------")
            let url = URL(fileURLWithPath: name)
            print(url)
            print("~~~~~~~~~~~~~~~~~~~~~~~")
            let res = NSWorkspace.shared.icon(forFile: url.path)
            print(res)


            
            var image = res
            let cgimage = image.toCGImage

            result(FlutterStandardTypedData(bytes: cgimage.png!))
            
            
            
            
            
            
            //            result(res)
//
//            return
        });
        

//        batteryChannel.setMethodCallHandler({
//          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//          // Note: this method is invoked on the UI thread.
//          guard call.method == "getBatteryLevel" else {
//            result(FlutterMethodNotImplemented)
//            return
//          }
//          self?.receiveBatteryLevel(result: result)
//
//        })

        
        
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


/*
 terminate method is like this
 public func terminate() {
     NSApplication.shared.terminate(nil)
 }
 */
