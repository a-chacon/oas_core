# Changelog

## [1.0.1](https://github.com/a-chacon/oas_core/compare/oas_core/v1.0.0...oas_core/v1.0.1) (2025-06-27)


### Bug Fixes

* Use rails compatible deep_merge version to prevent conflicts ([#23](https://github.com/a-chacon/oas_core/issues/23)) ([b6fb653](https://github.com/a-chacon/oas_core/commit/b6fb653dadc9d3769b7ba7e3aad373902f4d4ecf))

## [1.0.0](https://github.com/a-chacon/oas_core/compare/oas_core/v0.5.3...oas_core/v1.0.0) (2025-06-21)


### ⚠ BREAKING CHANGES

* support references for schemas of responses, request bodies and examples ([#19](https://github.com/a-chacon/oas_core/issues/19))

### Features

* Implement of reference tags ([@request](https://github.com/request)_body_ref, [@response](https://github.com/response)_ref, [@parameter](https://github.com/parameter)_ref) ([#20](https://github.com/a-chacon/oas_core/issues/20)) ([f9509e7](https://github.com/a-chacon/oas_core/commit/f9509e7f45bce2634cba81bdc8f759afdc4975ac))
* support references for schemas of responses, request bodies and examples ([#19](https://github.com/a-chacon/oas_core/issues/19)) ([0b0cce7](https://github.com/a-chacon/oas_core/commit/0b0cce75abc142cb6cd529bca52517767177fa57))


### Documentation

* add oas_hanami to book ([5233231](https://github.com/a-chacon/oas_core/commit/52332312775654b3da972e6a785c361d980b1f5e))
* **book:** add new tags, update old and new section of configuring oas source ([#22](https://github.com/a-chacon/oas_core/issues/22)) ([3a5db97](https://github.com/a-chacon/oas_core/commit/3a5db9786e1dfed9cae85583b2c9dc3cccfe34d4))
* **readme:** update list of adapters ([6d37e47](https://github.com/a-chacon/oas_core/commit/6d37e4748ece2e36cb4574d398a117c08635ceef))

## [0.5.3](https://github.com/a-chacon/oas_core/compare/oas_core/v0.5.2...oas_core/v0.5.3) (2025-06-14)


### Bug Fixes

* add args to config initializer for be able to replace default info ([e953cf7](https://github.com/a-chacon/oas_core/commit/e953cf7b75e216e87811f42144ae1b042c17c4db))

## [0.5.2](https://github.com/a-chacon/oas_core/compare/oas_core/v0.5.1...oas_core/v0.5.2) (2025-06-14)


### Documentation

* fix oas_rails documentation reference to oas_core ([cc7396a](https://github.com/a-chacon/oas_core/commit/cc7396a25c34a49d3b7d6560ee0386633cbd0642))


### Code Refactoring

* clean oas_route unused variables ([be647a2](https://github.com/a-chacon/oas_core/commit/be647a20a383a0fabdd7c1622d8c472e44f93b51))

## [0.5.1](https://github.com/a-chacon/oas_core/compare/oas_core/v0.5.0...oas_core/v0.5.1) (2025-06-09)


### Bug Fixes

* add activesupport dependency so there is no need to replace all rails methods for manage strings ([c337af4](https://github.com/a-chacon/oas_core/commit/c337af403f9c3b8e658324f3b2f08abc816b75c7))

## [0.5.0](https://github.com/a-chacon/oas_core/compare/oas_core/v0.4.0...oas_core/v0.5.0) (2025-06-09)


### Features

* replace try for safe navigator. (try is rails specific method) ([d5d58cd](https://github.com/a-chacon/oas_core/commit/d5d58cddd018455471b0de83a165e990a5ed7154))


### Documentation

* update mdbook documentation ([ba41005](https://github.com/a-chacon/oas_core/commit/ba41005b257e5d3456b37ed8dfdb43cbfc77b179))
* update readme ([f71b0a8](https://github.com/a-chacon/oas_core/commit/f71b0a885590c9216cd666ccd31236686d9d8f35))

## [0.4.0](https://github.com/a-chacon/oas_core/compare/oas_core/v0.3.0...oas_core/v0.4.0) (2025-06-08)


### Features

* implement custom type parsers for json schema generator ([cf114bb](https://github.com/a-chacon/oas_core/commit/cf114bb0d009c78533287445225f06e6139a929d))


### Bug Fixes

* path params from oas route ([52b2216](https://github.com/a-chacon/oas_core/commit/52b2216b7f6a79a873b24efeafc502b94290b265))


### Tests

* add reporters to test output ([d946437](https://github.com/a-chacon/oas_core/commit/d946437190751b50936b955cbf16a6d80df6d264))

## [0.3.0](https://github.com/a-chacon/oas_core/compare/oas_core/v0.2.0...oas_core/v0.3.0) (2025-06-06)


### Features

* add the content type dynamically with the tags ([2920a1a](https://github.com/a-chacon/oas_core/commit/2920a1ad468d800993e7fceb66f0bf760ac85a37))

## [0.2.0](https://github.com/a-chacon/oas_core/compare/oas_core/v0.1.0...oas_core/v0.2.0) (2025-06-03)


### Features

* implement a setter for configuration object ([9e3b108](https://github.com/a-chacon/oas_core/commit/9e3b108d04ae573f150daed081ebb0c2b65f396f))

## [0.1.0](https://github.com/a-chacon/oas_core/compare/oas_core-v0.0.1...oas_core/v0.1.0) (2025-06-02)


### Features

* first working release ([7881ce8](https://github.com/a-chacon/oas_core/commit/7881ce848134763b262941b944bf9d904fa46c89))


### Documentation

* update description and readme ([7881ce8](https://github.com/a-chacon/oas_core/commit/7881ce848134763b262941b944bf9d904fa46c89))
* update gem description ([7881ce8](https://github.com/a-chacon/oas_core/commit/7881ce848134763b262941b944bf9d904fa46c89))
