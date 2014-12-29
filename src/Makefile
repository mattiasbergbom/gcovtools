CXX=clang++
CFLAGS=-I. --coverage
DEPS = test.h
OBJ = test.o test1.o test2.o test3.o
SPECDIR = ../spec/gcov2x
OUTDIR = $(SPECDIR)/data
OUTDIR_CAT = $(SPECDIR)/concat

all: $(OUTDIR)/test.cpp.gcov $(OUTDIR)/test1.cpp.gcov $(OUTDIR)/test2.cpp.gcov $(OUTDIR)/data2/test3.cpp.gcov $(OUTDIR)/data2/test3.cpp.gcov $(OUTDIR_CAT)/test_cat.cpp.gcov

$(OUTDIR)/test.cpp.gcov: test.cpp.gcov $(OUTDIR)
	@cp -fv $< $@

$(OUTDIR)/test1.cpp.gcov: test1.cpp.gcov $(OUTDIR)
	@cp -fv $< $@

$(OUTDIR)/test2.cpp.gcov: test2.cpp.gcov $(OUTDIR)
	@cp -fv $< $@

$(OUTDIR)/data2/test3.cpp.gcov: test3.cpp.gcov $(OUTDIR)/data2
	@cp -fv $< $@

$(OUTDIR_CAT)/test_cat.cpp.gcov: test.cpp.gcov test1.cpp.gcov
	@echo "\nCreating $@\n"
	@cat $^ > $@

%.cpp.gcov: %.cpp test
	@./test
	@llvm-cov -l -p $<

test: $(OBJ)
	$(CXX) $(CFLAGS) -o $@ $^ 

%.o: %.cpp $(DEPS)
	$(CXX) $(CFLAGS) -c -o $@ $< 

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(OUTDIR)/data2:
	mkdir -p $(OUTDIR)/data2

$(OUTDIR_CAT):
	mkdir -p $(OUTDIR_CAT)

clean:
	@rm -f *.o *.gcda *.gcno *.gcov
	@rm -f test