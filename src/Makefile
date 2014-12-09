CXX=clang++
CFLAGS=-I. --coverage
DEPS = test.h
OBJ = test.o test1.o test2.o test3.o
OUTDIR = ../spec/data

all: $(OUTDIR)/test.cpp.gcov $(OUTDIR)/test1.cpp.gcov $(OUTDIR)/test2.cpp.gcov $(OUTDIR)/data2/test3.cpp.gcov

$(OUTDIR)/test.cpp.gcov: test.cpp.gcov
	@cp -fv $< $@

$(OUTDIR)/test1.cpp.gcov: test1.cpp.gcov
	@cp -fv $< $@

$(OUTDIR)/test2.cpp.gcov: test2.cpp.gcov
	@cp -fv $< $@

$(OUTDIR)/data2/test3.cpp.gcov: test3.cpp.gcov
	@cp -fv $< $@

%.cpp.gcov: %.cpp test
	@./test
	@llvm-cov -l -p $<

test: $(OBJ)
	$(CXX) $(CFLAGS) -o $@ $^ 

%.o: %.cpp $(DEPS)
	$(CXX) $(CFLAGS) -c -o $@ $< 

clean:
	@rm -f *.o *.gcda *.gcno *.gcov
	@rm -f test