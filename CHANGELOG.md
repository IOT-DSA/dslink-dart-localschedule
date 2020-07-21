# ChangeLog

## 2.0.3

### Bug Fixes

* Restore `data` node under the root of the link. This replaces the broker's data node with one that will keep the
data with the DSLink configuration rather than at broker level. 

## 2.0.2

### Features

* Add Event actions all return the newly created Event ID.

## 2.0.1

### Bug Fixes

* Resolved, and defined, behaviour for two overlapping events.

## 2.0.0

### Features
* Initial Release
* Remove legacy code.

### Bug Fixes
* Resolve an issue where the DSLink would not save after removing a schedule or event.