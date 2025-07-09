### 6.0.0 2025-07-09

* Breaking changes
  * Remove support for Ruby versions < 3.2.8.>
  * Minimum Ruby version is now 3.2.8
* Other Changes
 * Update gems.
 * Add 'observer' gem to dependencies.

### 5.0.13 2024-08-03

* Changes
 * Update gems.

### 5.0.12 2024-08-03

* Changes
 * Update gems.
 * Update rexml gem to patch CVE.

### 5.0.11 2024-02-18

* Changes
 * Update gems.

### 5.0.10 2024-01-07

* Changes
 * Relax ruby version requirements Gem::Requirement.new('>= 3.0.1', '< 4.0')
 * Update gems.

### 5.0.9 2023-12-28
* Changes
  * Ruby gem updates.
  * Add github actions to run specs.

### 5.0.8 2023-12-02
* Changes
  * Ruby gem updates.

### 5.0.7 2023-10-30
* Changes
  * Ruby gem updates.

### 5.0.6
* Changes
  * Ruby gem updates.

### 5.0.5
* Changes
  * Ruby gem updates.

### 5.0.4
* Changes
  * Fix README.md erroneous references to WordResults#successful? (should be #success?)
  * Gem update.

### 5.0.3
* Changes
  * Update gems to patch CVE.

### 5.0.2
* Changes
  * Update gems.

### 5.0.1
* Bug Fix
  * Fix error loading support files in LittleWeasel.rb.

### 5.0.0
* Changes
  * Add spec coverage where lacking.
  * Remove unused DictionaryLoaderService and associated modules, specs, factories.
  * Refactor Locale, Language and Region modules to simplify.
  * Fix up DictionaryManager#dictionary_for which was published
    half-baked in 4.0.0.
  * DeprecateDictionaryCacheService#dictionary_exists? (plural); add typical DeprecateDictionaryCacheService#dictionary_exist? method in its palce.
  *  Update rake gem version to eliminate command injection vulerability.
  * Change description and summary reflecting 4.0.0 Changes.
  * Various reek gem violation fixes/suppressions where reasonable.
  * Fix most rubocop violations.

### 4.0.0
* Enhancements
  * Complete overhaul; see README.md

### 3.0.4
* Enhancements
  * Relax requirements on ruby version to ~> 2.0.

### 3.0.3

* Enhancements
  * Add single_word_mode option (default: false); when single_word_mode: true, LittleWeasel::Checker.instance.exists? will return false, if more than one word is being checked for existance.

### 3.0.2

* Enhancements
  * None

* Bug Fix
  * Calling #exists? no longer alters the original input.
