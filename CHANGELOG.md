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