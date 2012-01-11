# Description

Command line tool to automate the process of getting new translations.

Features include:

  * Generate a list all English translations that have been updated or added since the last translation
  * Integrate a list of newly translated strings into the right place in the project translation file(s)

# Installation

Install the gem in your project

    gem install vocab

Set the current git commit to be the starting point for the next translation diff

    vocab init

# Usage

## Extracting Changed and Updated Strings For Translation

    vocab extract

## Extracting Changed and Updated Strings For Translation

    TBD

# TODO

  * export strings that have been added or updated since the last translation
  * import newly translated strings to their appropriate spot in the string file
  * add usage and help messages
  * handle android string files too