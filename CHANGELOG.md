### 5.0.0
* changes
  * Add spec coverage where lacking.
  * Remove unused DictionaryLoaderService and associated modules, specs, factories.
  * Refactor Locale, Language and Region modules to simplify.
  * Fix up DictionaryManager#dictionary_for which was published
    half-baked in 4.0.0.
  * DeprecateDictionaryCacheService#dictionary_exists? (plural); add typical DeprecateDictionaryCacheService#dictionary_exist? method in its palce.
  *  Update rake gem version to eliminate command injection vulerability.
  * Change description and summary reflecting 4.0.0 changes.
  * Various reek gem violation fixes/suppressions where reasonable.
  * Fix most rubocop violations.

### 4.0.0
* enhancements
  * Complete overhaul; see README.md

### 3.0.4
* enhancements
  * Relax requirements on ruby version to ~> 2.0.

### 3.0.3

* enhancements
  * Add single_word_mode option (default: false); when single_word_mode: true, LittleWeasel::Checker.instance.exists? will return false, if more than one word is being checked for existance.

### 3.0.2

* enhancements
  * None

* bug fix
  * Calling #exists? no longer alters the original input.
