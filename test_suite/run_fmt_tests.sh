#!/bin/bash

# Copyright 2015 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source "tests.source"

# Enable next line to test the garbage collector
#PARAMS="--gc-min-objects 1 --gc-growth-trigger 1"

# Enable next line for a slow and thorough test
#VALGRIND="valgrind -q"

#VERBOSE=true

for TEST in *.jsonlang ../examples/*.jsonlang ../examples/terraform/*.jsonlang ../benchmarks/*.jsonlang ../gc_stress/*.jsonlang ; do

    GOLDEN_OUTPUT="$(cat $TEST)"
    GOLDEN_KIND="PLAIN"

    if [ -r "$TEST.fmt.golden" ] ; then
        GOLDEN_OUTPUT=$(cat "$TEST.fmt.golden")
    fi

    if [ $(echo "$TEST" | cut -b 1-12) == "error.parse." ] ; then
        continue  # No point testing these
    fi

    EXPECTED_EXIT_CODE=0
    JSONLANG_CMD="$VALGRIND ../jsonlang fmt"
    test_eval "$JSONLANG_CMD" "$TEST" "$EXPECTED_EXIT_CODE" "$GOLDEN_OUTPUT" "$GOLDEN_KIND"
done

if [ $FAILED -eq 0 ] ; then
    echo "All $EXECUTED test scripts pass."
else
    echo "FAILED: $FAILED / $EXECUTED"
    exit 1
fi