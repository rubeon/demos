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
from itertools import groupby
from operator import itemgetter
import sys

def input_data(file, separator='\t'):
    for l in file:
        yield l.rstrip().split(separator, 1)

def main(separator='\t'):
    data = input_data(sys.stdin, separator=separator)
    for cw, group in groupby(data, itemgetter(0)):
        tot_count = sum(int(count) for cw, count in group)
        print "%s%s%d" % (cw, separator, tot_count)

if __name__ == "__main__":
    main()
