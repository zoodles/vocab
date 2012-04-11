# Description

Need to be able to send more than 1 translation to the translators at a time.

# Use Case

    1.  Extract strings and send them off for translation
    1.  Developer adds additional strings to project while strings are still at translator
    1.  Extract new strings and send them to developer
    1.  Get first set of strings back from translators, and integrate them
    1.  Get second set of strings back from translators, and integrate them

# Architecture

    * Update the SHA hash on extract instead of merge

# Implementation

