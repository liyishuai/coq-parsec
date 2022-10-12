<!---
This file was generated from `meta.yml`, please do not edit manually.
Follow the instructions on https://github.com/coq-community/templates to regenerate.
--->
# Parsec

[![Docker CI][docker-action-shield]][docker-action-link]

[docker-action-shield]: https://github.com/liyishuai/coq-parsec/workflows/Docker%20CI/badge.svg?branch=master
[docker-action-link]: https://github.com/liyishuai/coq-parsec/actions?query=workflow:"Docker%20CI"




Inspired by Haskell Parsec library.

## Meta

- Author(s):
  - Yishuai Li [<img src="https://zenodo.org/static/img/orcid.svg" height="14px" alt="ORCID logo" />](https://orcid.org/0000-0002-5728-5903)
  - Azzam Althagafi
  - Yao Li [<img src="https://zenodo.org/static/img/orcid.svg" height="14px" alt="ORCID logo" />](https://orcid.org/0000-0001-8720-883X)
  - Li-yao Xia [<img src="https://zenodo.org/static/img/orcid.svg" height="14px" alt="ORCID logo" />](https://orcid.org/0000-0003-2673-4400)
  - Benjamin C. Pierce [<img src="https://zenodo.org/static/img/orcid.svg" height="14px" alt="ORCID logo" />](https://orcid.org/0000-0001-7839-1636)
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



