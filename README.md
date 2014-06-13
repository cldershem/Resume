Resume
======

Repo containing the LaTeX and PDF versions of my resume.

`makeresume.py` builds several resumes from a single `yaml` file containing the
raw text.

Current versions of my resume will be in the master branch.

Older resumes (pre-script) are in `origs`.

To build generic (non-Dev) resume toggle comments:
    '''latex
     %\booltrue{isGeneric}
     \boolfalse{isGeneric}
    '''
