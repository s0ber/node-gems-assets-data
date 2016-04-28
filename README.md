node-gems-assets-data
=====================

Small utility for getting you gems path and set of paths, where gems assets are located.

## Version

0.1.1

## Installation

```
npm install gems-assets-data
```

## Usage

This package helps to resolve gems path, you should have *bundler* installed for this and be in the root of your application directory. It also can provide list of paths, where gems assets are located. This is useful, if you want to find all places, where *sprockets* manifests can be located.

### API

```coffee
GemsAssetsData = require('gems-assets-data')
gemsAssets = new GemsAssetsData()

gemsAssets.resolve().then ->
  gemsAssets.path()
  gemsAssets.dirs()
```

#### GemsAssetsData.prototype.resolve()

This is method, which actually resolves all data, it is working asynchrounously and returns deferred object. After data is resolved, you can get access to it.

#### GemsAssetsData.prototype.path()

Returns previously resolved local gems path.

#### GemsAssetsData.prototype.dirs()

Returns previously resolved gems assets paths.

## Using with gulp

You can integrate this with *gulp* easily.

```coffee
gulp = require('gulp')
karma = require('gulp-karma')
GemsAssetsData = require('gems-assets-data')

gemsAssets = new GemsAssetsData()

# this is the task, which resolves gems assets data
gulp.task 'resolve_gems_data', ->
  gemsAssets.resolve()

# this is using previously defined task
gulp.task 'karma:ci', ['resolve_gems_data'], ->
  # you can get access to gems assets data now
  gemsDirs = gemsAssets.dirs()
```

Then we can perform this task.

```
gulp --require coffee-script/register karma:ci
```
