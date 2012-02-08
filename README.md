# Description

Command line tool to automate the manipulation of i18n string files in Rails and Android.

Features include:

  * Generate a list all English translations that have been updated or added since the last translation
  * Integrate a list of newly translated strings into the right place in the project translation file(s)
  * Validate that all languages have the same keys

# Requirements

  * Must be used in context of git controlled project
  * Assumes that android string files are called strings.xml

# Installation

Install the gem in your project

    gem install vocab

Set the current git commit to be the starting point for the next translation diff

    vocab init

# Usage

## Extracting Changed and Updated Strings For Translation

    vocab extract android

    or

    vocab extract rails

## Merging new translations into project string files

    vocab merge android

    or

    vocab merge rails

## Merging new translations into project string files

    vocab validate android

    or

    vocab validate rails

# TODO

  * Add .processed to each tmp/translation after success
  * Accept filenames other than strings.xml under tmp/translation/values-xx/yyyy.xml
