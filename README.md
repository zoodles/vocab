# Description

Command line tool to automate the manipulation of i18n string files in Rails and Android.

## Features include:

  * Generate a list all English translations that have been updated or added since the last translation
  * Integrate a list of newly translated strings into the right place in the project translation file(s)
  * Validate that all languages have the same keys

# Requirements

  * Must be used in context of git controlled project
  * Assumes that android string files are called strings.xml under res/values-xx

# Installation

Install the gem in your project

    gem install vocab

Set the current git commit to be the starting point for the next translation diff

    vocab init

You may need to change the SHA hash in .vocab to match the commit of the last translation

# Usage

## Android

### Extract Changed and Updated Strings For Translation

    cd APP_ROOT
    vocab extract android

This will create two files in the current directory:

`strings.diff.xml` Contains all the keys that need to be updated for existing languages
`strings.full.xml` Contains all keys for a full translation

Send these files off to the appropriate translator.  When they files come back,
put the partial language translations in `tmp/translations`.  For example:

    tmp/translations/values-zn/strings.xml
    tmp/translations/values-es/es-strings-7.xml

The file must be in the properly named folder and end with xml.

For new language files, just put them directly under the `res` directory.

### Merging new translations into project string files

Integrate the translations with the following command:

    cd APP_ROOT
    vocab merge android

### Validating that all translations have the same keys

    cd APP_ROOT
    vocab validate android

## Rails

### Extract Changed and Updated Strings For Translation

    cd RAILS_ROOT
    vocab extract rails

This will create two files in the current directory:

`en.diff.yml` Contains all the keys that need to be updated for existing languages
`en.full.yml` Contains all keys for a full translation

Send these files off to the appropriate translator.  When they files come back,
put them in `tmp/translations`.  For example:

    tmp/translations/zn.yml
    tmp/translations/es.yml

### Merging new translations into project string files

Integrate the translations with the following command:

    cd RAILS_ROOT
    vocab merge rails

 Keys will be put in the correct nested yml file.  You can put whole or partial translations
 in tmp/translations.

### Validating that all translations have the same keys

    cd RAILS_ROOT
    vocab validate rails

# Other details

Keys starting with 'debug_' are ignored for both Rails and Android string files.  Prepend development-only strings
with 'debug_' to avoid these keys being sent to translators.

# TODO

  * Add .processed to each tmp/translation after success
  * Handle full translations under tmp/translations when no existing translation exists in android
  * Add iOS support
  * Add AIR support
  * Add Chrome support
  * Add Firefox support
  