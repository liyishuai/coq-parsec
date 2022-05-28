<!---
This file was generated from `meta.yml`, please do not edit manually.
Follow the instructions on https://github.com/coq-community/templates to regenerate.
--->
# Parsec

[![CircleCI][circleci-shield]][circleci-link]

[circleci-shield]: https://circleci.com/gh/liyishuai/coq-parsec.svg?style=svg
[circleci-link]:   https://circleci.com/gh/liyishuai/coq-parsec




Inspired by Haskell Parsec library.

## Meta

- Author(s):
  - Yishuai Li
  - Azzam Althagafi
  - Yao Li
  - Li-yao Xia
  - Benjamin C. Pierce
- License: [BSD 3-Clause "New" or "Revised" License](LICENSE)
- Compatible Coq versions: 8.14 or later
- Additional dependencies:
  - [Cérès](https://github.com/Lysxia/coq-ceres)
  - [ExtLib](https://coq-community.org/coq-ext-lib/)
- Coq namespace: `Parsec`
- Related publication(s): none

## Building and installation instructions

The easiest way to install the latest released version of Parsec
is via [OPAM](https://opam.ocaml.org/doc/Install.html):

```shell
opam repo add coq-released https://coq.inria.fr/opam/released
opam install coq-parsec
```

To instead build and install manually, do:

``` shell
git clone https://github.com/liyishuai/coq-parsec.git
cd coq-parsec
make   # or make -j <number-of-cores-on-your-machine> 
make install
```



