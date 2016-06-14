#!/usr/bin/env python
# coding=utf-8
#
# Create ROCs
#
# Author:
#
# Peter Krusche <pkrusche@illumina.com>
#
import jinja2
import json

from template import TEMPLATEDIR


def render_roc(roc_name, data):
    """Render a ROC curve via D3

    :param roc_name: name of the ROC (must be unique in document)
    :param data: data as something that can be turned into JSON
    :return: HTML that can be included in output
    """

    loader = jinja2.FileSystemLoader(TEMPLATEDIR)
    env = jinja2.Environment(loader=loader)

    template_vars = {
        "roc_name": roc_name,
        "data": json.dumps(json.dumps(data))
    }

    template = env.get_template("roc_plot.jinja2.html")
    return template.render(**template_vars)

