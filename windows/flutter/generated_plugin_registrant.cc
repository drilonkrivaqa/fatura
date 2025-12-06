//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <file_picker_windows/file_picker_windows_plugin.h>
#include <path_provider_windows/path_provider_windows_plugin.h>
#include <printing/printing_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FilePickerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FilePickerWindowsPlugin"));
  PathProviderWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PathProviderWindowsPlugin"));
  PrintingPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PrintingPlugin"));
}
