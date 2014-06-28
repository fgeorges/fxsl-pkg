fxsl-pkg
========

Package builder for the FXSL library.

This project is used to create a package out of FXSL.  It does not
contain the sources of FXSL themselves, but needs them to be built.
Just copy the FXSL `f/` directory (from CVS) to `src/f/` before
building this project (do not check them in!)

As we do not want to modify FXSL sources, we cannot add the public
import URIs within the stylesheets themselves, so we cannot use
XProject and we need to provide an explicit expath-pkg.xml descriptor.
Instead of writing it by hand, it is generated from the content of
`src/f/`.  Just run the following command by using an XSLT 2.0
processor (e.g. Saxon), with the EXPath modules **Files** and **ZIP**
installed:

```
saxon -xsl:build/make-project.xsl -s:build/make-project.xsl
```
