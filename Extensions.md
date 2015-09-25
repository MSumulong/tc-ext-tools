# Extensions in tc-ext-tools #

In package root file system extensions are located under the extensions directory. Any extension that has the **install** file will be treated as an extension to be created.

## Package files list ##

The list of all files in the package. It is located under the package root extensions directory. Use this list to prepare extension install files.

```
extensions/list
```

## Extension files to edit ##
```
common
dep
install
tce.installed
```

### common ###

By default extensions are named after the directory names in package root extensions folder. If you wish to change the name then set **NAME** in the **extension's common** file

```
NAME=EXTENSION_NAME
```

Also you can override extension info variables in extension's common file such as DESCRIPTION, COMMENTS etc.

tc-ext-tools automatically append strings to specific extensions' description such as -dev, -locale, -doc however you can always override these varibles using extension's common file

### dep ###

This is the dependecies list of the extension. Remember you can comment out any line with the # operator.

### install ###

This is one of the best features of tc-ext-tools. Just like in a debian package you can set this file similarly to install files which will go into your extension.

To exclude files or directories use x- operator
```
path/to/include
x-path/to/exclude
```

_See the package files list under the extensions directory_

### tce.installed ###

This is the script that is executed when the extension is loaded. Don't worry about permissions they will be set by tc-ext-tools.

**Sercan Arslan**
<arslanserc@gmail.com>