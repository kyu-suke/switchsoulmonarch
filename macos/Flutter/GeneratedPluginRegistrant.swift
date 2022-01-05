//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import hotkey_holder
import magnetica
import sqflite
import system_tray
import tray_manager
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  HotkeyHolderPlugin.register(with: registry.registrar(forPlugin: "HotkeyHolderPlugin"))
  MagneticaPlugin.register(with: registry.registrar(forPlugin: "MagneticaPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  SystemTrayPlugin.register(with: registry.registrar(forPlugin: "SystemTrayPlugin"))
  TrayManagerPlugin.register(with: registry.registrar(forPlugin: "TrayManagerPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
