//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import hotkey_holder
import hotkey_manager
import magnetica
import sqflite
import system_tray
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  HotkeyHolderPlugin.register(with: registry.registrar(forPlugin: "HotkeyHolderPlugin"))
  HotkeyManagerPlugin.register(with: registry.registrar(forPlugin: "HotkeyManagerPlugin"))
  MagneticaPlugin.register(with: registry.registrar(forPlugin: "MagneticaPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  SystemTrayPlugin.register(with: registry.registrar(forPlugin: "SystemTrayPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
