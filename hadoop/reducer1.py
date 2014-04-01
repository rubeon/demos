#!/usr/bin/env python
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
import sys
from operator import itemgetter

cw = None
curr_count = 0
word = None

for l in sys.stdin:
    l = l.strip()

    #split
    word, count = l.split('\t', 1)

    count = int(count)

    if cw == word:
        curr_count += count
    else:
        if cw:
            print '%s\t%s' % (cw, curr_count)
        cw = count
        cw = word

if cw == word:
    print '%s\t%s' % (cw, curr_count)
