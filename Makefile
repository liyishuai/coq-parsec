COQMAKEFILE?=Makefile.coq

all: $(COQMAKEFILE)
	@+$(MAKE) -f $^ $@

clean: $(COQMAKEFILE)
	@+$(MAKE) -f $^ cleanall
	@rm -f $^ $^.conf */*~
	$(MAKE) -C test $@

$(COQMAKEFILE): _CoqProject
	$(COQBIN)coq_makefile -f $^ -o $@

test:
	@+$(MAKE) -C test

force _CoqProject Makefile: ;

%: $(COQMAKEFILE) force
	@+$(MAKE) -f $< $@

.PHONY: all clean force test

publish%:
	opam publish --packages-directory=released/packages \
		--repo=coq/opam-coq-archive --tag=v$* -v $* liyishuai/coq-parsec
