gcovtools
======

![Travis CI Status](https://travis-ci.org/mattiasbergbom/gcovtools.svg)

**gcovtools** provides various tools and utilities for processing coverage data emitted from [llvm-cov](http://llvm.org/docs/CommandGuide/llvm-cov.html).

Quick Start
-----------

First, unless you haven't already done so, compile your project using ```clang --coverage``` and digest the output using ```llvm-cov``` (see the `src` dir for examples). You should end up with one or more ```.gcov``` files.

Next, install the gem:

```gem install gcovtools```

This should furnish you with a ```gcovtools``` executable in your path.

Finally, execute ```gcovtools``` in one of multiple possible ways. 

For instance, generate a HTML coverage report and pipe it to ```coverage.html```:

```gcovtools report --format html *.gcov > coverage.html```

Ditto using recursive directory search:

```gcovtools report --format html ../some/dir -r > coverage.html```

Applying a few filters to only include certain source files once extracted from the gcov files, using regular expressions:

```gcovtools report --format html ../some/dir -r --include subdir/.*\.cpp$ otherdir/.*\.h$ --exclude \.s\.cpp$ > coverage.html```

That last bit will include all files ending with ```.cpp``` anywhere under some directory named ```subdir```, all files ending with ```.h``` anywhere under some directory named ```otherdir``, but will exclude any file ending with ```.s.cpp``` (which is how someone may name, say, behavioral specification drivers).

Disclaimer
----------
This is a work in progress.
