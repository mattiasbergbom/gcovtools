gcov2x
======

![Travis CI Status](https://travis-ci.org/mattiasbergbom/gcov2x.svg)

**gcov2x** takes coverage data emitted from [llvm-cov](http://llvm.org/docs/CommandGuide/llvm-cov.html) and aggregates it into various formats, some more easily interpreted by humans, some better suited for machines.

Quick Start
-----------

First, unless you haven't already done so, compile your project using ```clang --coverage``` and digest the output using ```llvm-cov``` (see the `src` dir for examples). You should end up with one or more ```.gcov``` files.

Next, install the gem:

```gem install gcov2x```

This should furnish you with a ```gcov2x``` executable in your path.

Finally, execute ```gcov2x``` in one of multiple possible ways. For instance, generate a HTML coverage report:

```gcov2x --format html *.gcov > coverage.html```

Disclaimer
----------
This is a work in progress.
