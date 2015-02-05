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

Finally, execute ```gcovtools``` in one of multiple possible ways. For instance, generate a HTML coverage report:

```gcovtools convert --format html *.gcov > coverage.html```

Disclaimer
----------
This is a work in progress.
