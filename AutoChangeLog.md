## Auto Change Log in tc-ext-tools ##

It is the **CHANGELOG** variable in package common or extension common file which have the highest priority. So you can still suppress this auto change-log feature by setting this variable in one of the common files.

Priority order of files: extension info from repo < package common < extension common

So any variable that is defined in package common will override the one from info.

If you want to use auto change-log feature then simply delete CHANGELOG or equalize CHANGELOG="---" (recommended) or CHANGELOG=""

**Sercan Arslan** <arslanserc@gmail.com>