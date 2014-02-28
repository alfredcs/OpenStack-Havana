#!/usr/bin/env python2.7
# Copyright 2013 The Cloudscaling Group, Inc. All Rights Reserved.
# Author: Benjamin Staffin <ben@cloudscaling.com>

"""Parse log output from strainer on stdin and prepare it for Jenkins to read.

Writes logs to individual output files based on the name of the tool run by
strainer, if and only if the tool is included in LOGMAP.  Optionally also
passes lines through a preprocessing function, dispatched from preprocess().

All input is passed through unchanged to stdout.  Lines that do not match a
LOGMAP tool entry are not parsed or written to any file, but they are still
passed through to stdout.
"""

import gflags
import os
import re
import sys

gflags.DEFINE_string(
    'basepath', os.path.abspath(os.curdir),
    'Base path for filename prefixes.')
gflags.DEFINE_string(
    'logdir', os.path.join(os.path.abspath(os.curdir), 'testlogs'),
    'Directory in which to write test logs.')

FLAGS = gflags.FLAGS

# Mapping from strainer test name to where its output is written.
LOGMAP = {
    'foodcritic': 'foodcritic.log',
    }


def preprocess(groupdict):
  """Preprocess a Strainer log line by passing it through a function map.

  If there is no matching function for the tool, just return the line.
  """

  funcmap = {
      'foodcritic': preprocess_foodcritic,
      }
  tool = groupdict['tool']
  if tool in funcmap:
    return funcmap[tool](groupdict['msg'])
  else:
    return groupdict['msg']


def preprocess_foodcritic(line):
  """Preprocess foodcritic log lines.

  Returns the line with absolute file paths rather than relative paths.
  """
  fc_re = (r'(?P<msgnum>[A-Z]+[0-9]+): (?P<msg>.*): '
           r'(?P<filename>[^:]+):(?P<linenum>[0-9]+)')
  match = re.match(fc_re, line)
  if match:
    groupdict = match.groupdict()
    groupdict['abspath'] = os.path.join(FLAGS.basepath, 'cookbooks',
                                        groupdict['filename'])
    return '{msgnum}: {msg}: {abspath}:{linenum}'.format(**groupdict)
  else:
    if not re.match('^SUCCESS!', line):
      return line


def strip_color(line):
  """Strip out ANSI color codes from a string."""
  ansi_re = r'\033\[((?:\d|;)*)([a-zA-Z])'
  return re.sub(ansi_re, '', line)


def main(argv):
  """Main."""
  try:
    argv = FLAGS(argv)
  except gflags.FlagsError as err:
    sys.stderr.write('%s\n\nUsage: %s\n%s' % (err, sys.argv[0], FLAGS))
    sys.stderr.write('\n')
    sys.stderr.flush()
    sys.exit(1)

  openlogs = {}
  try:
    while True:
      line = raw_input()
      print line
      sys.stdout.flush()  # Do not buffer console output.
      match = re.match(r'(?P<tool>\w+)\s+\|\s+(?P<msg>.*)', strip_color(line))
      if match:
        groupdict = match.groupdict()
        tool = groupdict['tool']
        if tool in LOGMAP:
          logfile = LOGMAP[tool]
          if logfile not in openlogs:
            if not os.path.isdir(FLAGS.logdir):
              os.makedirs(FLAGS.logdir)
            openlogs[logfile] = open(os.path.join(FLAGS.logdir, logfile), 'a')
          processed_line = preprocess(groupdict)
          if processed_line:
            openlogs[logfile].write(processed_line)
            openlogs[logfile].write('\n')
  except EOFError:
    # Done!
    pass


if __name__ == '__main__':
  main(sys.argv)
