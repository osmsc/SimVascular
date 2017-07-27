/* Copyright (c) 2009-2011 Open Source Medical Software Corporation,
 *                         University of California, San Diego.
 *
 * All rights reserved.
 *
 * Portions of the code Copyright (c) 1998-2007 Stanford University,
 * Charles Taylor, Nathan Wilson, Ken Wang.
 *
 * See SimVascular Acknowledgements file for additional
 * contributors to the source code.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject
 * to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#ifdef SV_USE_MITK

#include "simvascularMitkApp.h"

#include <iostream>

simvascularApp::simvascularApp(int argc, char* argv[]) : BaseApplication(argc, argv)
{
}

simvascularApp::~simvascularApp()
{
}
#endif

#ifdef SV_USE_MITK

void simvascularApp::initializeLibraryPaths() {

  std::cout << "\n\n *** simvascularApp: initializeLibraryPaths! *** \n\n" << std::endl << std::flush;

  bool found_sv_plugin_path = false;

  //
  //  This is SV code to start using env variables and registry
  //  to specify library paths.
  //

  // read environment variables for plugin paths
#ifdef WIN32
  char plugin_env[_MAX_ENV];
  size_t requiredSize;
  plugin_env[0]='\0';
  requiredSize = 0;
  getenv_s( &requiredSize, NULL, 0, "SV_PLUGIN_PATH");

  if (requiredSize == 0) {
    std::cerr << "Warning:  SV_PLUGIN_PATH doesn't exist!\n" << std::endl << std::flush;
  } else if (requiredSize >= _MAX_ENV) {
    std::cerr << "FATAL ERROR:  SV_PLUGIN_PATH to long!\n" << std::endl << std::flush;
    exit(-1);
  } else {
    found_sv_plugin_path = true;
    getenv_s( &requiredSize, plugin_env, requiredSize, "SV_PLUGIN_PATH" );
    char seps[] = ";";
    char *token;
    token = strtok( plugin_env, seps );
    while( token != NULL ) {
      // While there are tokens in "string"
      printf( " %s\n", token );
      QString pluginPath = token;
      ctkPluginFrameworkLauncher::addSearchPath(pluginPath);
      std::cout << "   Adding to plugin search path (" << pluginPath.toStdString() << ")" << std::endl << std::flush;
      // Get next token
      token = strtok( NULL, seps );
    }
  }
#else
  char *plugin_env = getenv("SV_PLUGIN_PATH");
  if (plugin_env == NULL) {
    std::cerr << "Warning:  SV_PLUGIN_PATH doesn't exist!\n" << std::endl << std::flush;
  } else {
    found_sv_plugin_path = true;
    char seps[] = ":";
    char *token;
    token = strtok( plugin_env, seps );
    while( token != NULL ) {
      // While there are tokens in "string"
      printf( " %s\n", token );
      QString pluginPath = token;
      ctkPluginFrameworkLauncher::addSearchPath(pluginPath);
      std::cout << "   Adding to plugin search path (" << pluginPath.toStdString() << ")" << std::endl << std::flush;
      // Get next token
      token = strtok( NULL, seps );
    }
  }
#endif

  //
  // This is the default behavior in AppUtil for MITK.
  //

  if (!found_sv_plugin_path) {
    QStringList suffixes;
    QDir appDir;

    suffixes << "plugins";
#ifdef WIN32
    suffixes << "bin/plugins";
#ifdef CMAKE_INTDIR
    suffixes << "bin/" CMAKE_INTDIR "/plugins";
#endif
#else
    suffixes << "lib/plugins";
#ifdef CMAKE_INTDIR
    suffixes << "lib/" CMAKE_INTDIR "/plugins";
#endif
#endif

#ifdef __APPLE__
    suffixes << "../../plugins";
#endif

    // we add a couple of standard library search paths for plug-ins
    appDir = QCoreApplication::applicationDirPath();

    // walk one directory up and add bin and lib sub-dirs; this
    // might be redundant
    appDir.cdUp();

    foreach(QString suffix, suffixes)
    {
      ctkPluginFrameworkLauncher::addSearchPath(appDir.absoluteFilePath(suffix));
    }

    suffixes << "plugins";
    suffixes << "bin/plugins";
    suffixes << "lib/plugins";

    // we add a couple of standard library search paths for plug-ins
    appDir = QCoreApplication::applicationDirPath();

    foreach(QString suffix, suffixes)
    {
      ctkPluginFrameworkLauncher::addSearchPath(appDir.absoluteFilePath(suffix));
      std::cout << "Adding to plugin search path (" << appDir.absoluteFilePath(suffix).toStdString() <<  ")" << std::endl << std::flush;
    }

  }

  //
  //  This code is a debugging check to make sure that all of the dll's
  //  can be found in the search path.
  //

  QVariant pluginsToStartVariant = this->getProperty(ctkPluginFrameworkLauncher::PROP_PLUGINS);
  QStringList pluginsToStart = pluginsToStartVariant.toStringList();

  for (QStringList::iterator it =  pluginsToStart.begin();
       it !=  pluginsToStart.end(); ++it) {
     QString current = *it;
     QString MypluginPath = ctkPluginFrameworkLauncher::getPluginPath(current);
     std::cout << "  plugin (" << current.toStdString() << ")" << std::endl << std::flush;
     std::cout << "    resolves to [" << MypluginPath.toStdString() << "]" << std::endl << std::flush;
  }

  return;
}

#endif
