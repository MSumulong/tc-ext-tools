## Source File Name ##

Name of a source file is determined simply by cutting the variable with "##`*`/".

```
SOURCE="http://download.videolan.org/pub/videolan/vlc/2.0.3/vlc-2.0.3.tar.xz"
```
In this case source file name would be vlc-2.0.3.tar.xz but in some cases the link is redirection so you need to define source file name explicitly by using "->" operator such as in this example given below.

```
SOURCE="http://minidlna.cvs.sourceforge.net/viewvc/minidlna/?view=tar->$PACKAGE-$VERSION.tar.gz"
```