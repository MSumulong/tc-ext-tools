## VCS support in tc-ext-tools ##

Version Control Systems (VCS) supported by tc-ext-tools

### svn ###
Set SOURCE in package common
```
SOURCE="svn::REPOSITORY_URL"
```

The download tool will check out the head revision however if you wish an older revision set SVN\_FLAGS
```
SVN_FLAGS="-r<REV>"
```

### git ###
Set SOURCE in package common
```
SOURCE="git::REPOSITORY_URL"
```

The download tool will check out the master branch however if you wish another branch set GIT\_FLAGS
```
GIT_FLAGS="-b<BRANCH>"
```

### hg (mercurial) ###
Set SOURCE in package common
```
SOURCE="hg::REPOSITORY_URL"
```

The download tool will check out the head revision however if you wish an older revision set HG\_FLAGS
```
HG_FLAGS="-r<REV>"
```

### bzr (bazaar) ###
Set SOURCE in package common
```
SOURCE="bzr::REPOSITORY_URL"
```

The download tool will check out the head revision however if you wish an older revision set BZR\_FLAGS
```
BZR_FLAGS="-r<REV>"
```