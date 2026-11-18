import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    // demo 验收窗口：1728×1080，居中显示
    let windowFrame = NSRect(x: 0, y: 0, width: 1728, height: 1080)
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    self.center()
    self.styleMask.insert(.fullSizeContentView)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
