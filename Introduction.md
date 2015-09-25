# Introduction #

tc-ext-tools is a package build system developed for Tiny Core Linux. The main aim of the project is to create a high level, easy and fast package maintenance system for Tiny Core Linux.

# Design Concepts #

  * Divide and conquer
    * The package building process is step by step.
  * Fast packaging
    * A new package can be created in just a few minutes.
  * Easy package maintenance
    * Updating a package is a simple task of editing just a few lines.
  * Each package has a source
    * The package source is an archive file or a VCS (Version Control System, i.e svn or git) repository.
    * Multiple source packages are also supported via custom defined build rules.
  * A package has extensions
    * We refer to a package as the parent of its extensions.
  * Host the packages at an online vcs repository.
    * Track and save the changes applied to packages with a version control system (svn).
  * Support for Tiny Core Linux specific features (tce.installed, wbar icon etc.)
    * Add wbar icon or install script without worrying about permissions and ownerships.
  * Error handling
    * The packager can sort out the problem by tracking the error messages.

# Installation #

Check out the latest source code from the svn repository and follow the instructions in INSTALL file.

```
svn checkout http://tc-ext-tools.googlecode.com/svn/trunk tc-ext-tools
cd tc-ext-tools
cp config.sample .config
./install.sh
```

# Usage #

## Hello World ##
  * It is easy to build a package
```
svn checkout http://tc-ext-tools.googlecode.com/svn/packages/libdvbpsi
cd libdvbpsi
buildit
```

## Creating a new package ##
  * First add the package with addit
```
addit --package=<package> --version=<version> --extensions="extension1 extension2 ..."
```
_Hint: version can be a number, "svn" or "git"._

  * Then edit the files in the package root directory by using your favorite file manager and text editor.

  * Most important variables that you need to specify in the common file are SOURCE, and BUILD\_DEPENDS. You also need to define configure, compile, install, and rules functions in the package build file.
_Note: The rules function is placed in the build file to give complete control to the user for defining the package build rules._

_Hint: SOURCE can be the direct link to a tarball or the url of an svn or git repository._

  * Then you can execute buildit in the package root directory to build the package with the rules defined in the build file.
```
buildit
```
  * When creating a package for the first time you better advance step by step.
```
buildit --clean|--load|--download|--convert|--unpack|--patch|--configure|--compile|--install|--split|--strip|--create|--generate|--check|--test|--package|--encrypt|--print|--help
```
  * There is also custom build function support which can be used for defining custom build rules.
```
buildit --custom <function>
```
_Hint: You need to define `build_<function>` in the package build file._
  * If you want to see configure, compile, install output messages.
```
buildit --print configure|compile|install
```
  * If an error occurs or you want to see low level messages.
```
buildit --print message
```

### See other available packages for more. ###
```
svn checkout http://tc-ext-tools.googlecode.com/svn/packages/ tc-ext-tools/packages
```

## tc-ext-tools shell environment ##

The shell environment is designed to make your life easier by implementing special shell functions such as changing parent's directory to a package's root directory, searching in the package, listing the contents of a package or even browsing and editing the package files.

_Note: A reboot or relogin is required for tc-ext-tools shell functions to be available for the first time installation._

### update-tet-database ###
  * Create a database from the packages located in the packages directory.
```
update-tet-database
```

### tetls ###
  * List the contents of a package
```
tetls <package>
```
_Hint: If `<package>` is left blank, tetls lists all available packages._

### tetcd ###
  * Change directory to a package's root
```
tetcd <package>
```
_Hint: If `<package>` is left blank, tetcd changes directory to the packages directory._

### tetfind ###
  * Find files in the package
```
tetfind <package> <file>
```
_Hint: If no argument is given, tetfind finds all the files in the packages directory. If only `<file>` is left blank, tetfind finds all the files in the package._

### teted ###
  * Edit the files of a package
```
teted <package> <file>
```
_Hint: If `<file>` is left blank, teted lists all the files in the package and asks you which one to edit. If a file name is specified it searches for the files with the name in the package, and if more than one file is found with the same name it asks you which one to edit. If the search matches only one file it opens the file for you to edit._

### tetbrowse ###
  * Browse the package in your file manager
```
tetbrowse <package>
```
_Hint: If the package is not specified, tetbrowse opens the tc-ext-tools packages directory._

### tetinfo ###
  * Show info about the package
```
tetinfo <package>
```
_Hint: You must specify the package name._

### tetwww ###
  * Open the package site in your web browser
```
tetwww <package>
```
_Hint: You must specify the package name._


**Sercan Arslan**

arslanserc@gmail.com