#!/usr/bin/env python
"""
    makeresume
    ~~~~~~~~~~

    Takes a json or yaml file and outputs two latex files.

    :author: Cameron Dershem <cldershem@gmail.com>
    :copyright: Cameron Dershem 2014
    :license:
"""
import yaml
import re
from jinja2 import Environment, FileSystemLoader
import subprocess
from contextlib import contextmanager


#   TODO:
#       relocate ResumeStyle.sty
#       figure out escapes (\&, \$, \LaTeX{})
#       update header to pull from yaml
#       projects needs to be a list to preserve order


env = Environment(loader=FileSystemLoader(
    '/home/cldershem/Documents/resume/CurrentResume/templates'))

templates = [
    ('Skills', 'tex'),
    # ('CoverLetter', 'tex'),
    # ('Gen', 'tex'),
    # # ('Html', 'html'),
    # ('Text', 'text'),
    ('Dev', 'tex'),
    ]

prefix = 'CameronDershemResume-'
output = './built'


def escape_tex(value):
    """
    Escapes special LaTex characters.
    """
    LATEX_SUBS = (
        (re.compile(r'\\'), r'\\textbackslash'),
        (re.compile(r'([{}_#%&$])'), r'\\\1'),
        (re.compile(r'~'), r'\~{}'),
        (re.compile(r'\^'), r'\^{}'),
        (re.compile(r'"'), r"''"),
        (re.compile(r'\.\.\.+'), r'\\ldots'),
    )
    newval = value
    for pattern, replacement in LATEX_SUBS:
        newval = pattern.sub(replacement, newval)
    return newval


def build_tex(template, name):
    """
    Builds latex file.
    """
    with set_env():
        with open('{}/{}{}.tex'.format(output, prefix, name), 'w+') as f:
            f.write(template.render(data=get_data()))


@contextmanager
def set_env():
    """
    Temporarily changes environmental variables for Jinja delimiters.
    """
    old_block_start_string = env.block_start_string
    old_block_end_string = env.block_end_string
    old_variable_start_string = env.variable_start_string
    old_variable_end_string = env.variable_end_string
    old_comment_start_string = env.comment_start_string
    old_comment_end_string = env.comment_end_string

    env.block_start_string = '((*'
    env.block_end_string = '*))'
    env.variable_start_string = '((('
    env.variable_end_string = ')))'
    env.comment_start_string = '((='
    env.comment_end_string = '=))'
    env.filters['escape_tex'] = escape_tex

    yield

    env.block_start_string = old_block_start_string
    env.block_end_string = old_block_end_string
    env.variable_start_string = old_variable_start_string
    env.variable_end_string = old_variable_end_string
    env.comment_start_string = old_comment_start_string
    env.comment_end_string = old_comment_end_string


def make_pdf(template, name):
    """
    Builds pdfs from latex.
    """
    command = "rubber --into {0} --pdf {0}/{2}{1}.tex".format(
        output, name, prefix)
    # command = "latexmk -quiet -aux-directory={0}/aux -output-directory={0} "\
    #            "-pdf {0}/{1}.tex".format(output, name)"
    subprocess.call(command.split())


def open_pdf(name):
    """
    Opens pdf.
    """
    command = "xdg-open {}/{}{}.pdf".format(output, prefix, name)
    subprocess.call(command.split())


def make_text(template, name):
    """
    Builds text file from template.
    """
    data = get_data()
    with open('{}/{}{}.txt'.format(output, prefix, name), 'w+') as f:
        f.write(template.render(data=data))


def get_data():
    """
    Prints out the data.
    """
    with open('resume.yaml', 'r') as ydata:
        ydata = yaml.load(ydata.read())
    return ydata


if __name__ == '__main__':
    for template in templates:
        name, file_type = template
        template = env.get_template("{}.jinja".format(name))
        if file_type == 'tex':
            build_tex(template, name)
            make_pdf(template, name)
            open_pdf(name)
        elif file_type == 'text':
            make_text(template, name)
        elif file_type == 'html':
            pass
        else:
            pass
