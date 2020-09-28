COQMAKEFILE?=Makefile.coq

all: $(COQMAKEFILE)
	@+$(MAKE) -f $^ $@

clean: $(COQMAKEFILE)
	@+$(MAKE) -f $^ cleanall
	@rm -f $^ $^.conf

$(COQMAKEFILE): _CoqProject
	$(COQBIN)coq_makefile -f $^ -o $@

test:
	@+$(MAKE) -C test

force _CoqProject Makefile: ;

%: $(COQMAKEFILE) force
	@+$(MAKE) -f $< $@

.PHONY: all clean force test
