# Description

Command line tool to automate the process of i18n string files in Rails and Android.

Features include:

  * Generate a list all English translations that have been updated or added since the last translation
  * Integrate a list of newly translated strings into the right place in the project translation file(s)

# Requirements

  * Must be used in context of git controlled project

# Installation

Install the gem in your project

    gem install vocab

Set the current git commit to be the starting point for the next translation diff

    vocab init

# Usage

## Extracting Changed and Updated Strings For Translation

    vocab extract_rails

## Merging new translations into project string files

    vocab merge_rails

# TODO

  * Add .processed to each tmp/translation after success

# Questions

  * What is the correct behavior is no translation available for key