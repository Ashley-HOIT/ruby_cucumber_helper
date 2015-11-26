# End to End tests 

## Install rvm:
```
$ \curl -sSL https://get.rvm.io | bash -s stable
```
#### Install Ruby 2.1.7
```
$ rvm install 2.1.7
$ rvm use 2.1.7
```
### Install bundler
```
$ gem install bundler
```
### Bundle install
```
$ cd ruby_cucumber_helper
$ bundle install
```
#### To run the tests with ENV variables:
```
$ BROWSER='chrome' cucumber -r features
use (-r) when .feature files are located within a sub directory of the features folder
```