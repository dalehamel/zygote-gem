![ci-status](https://travis-ci.org/dalehamel/zygote.svg)

# Zygote

Zygote is a PXE automation framework that allows you to easily generate an iPXE boot menus.

# Technical

## Menus

Implementing a menu is easy.

* Create a folder inside 'cells'
* Add a menu.erb file to your folder, this can be boiler plate or as complicated as you want
* Add a boot.erb that describes how to actually boot your desired cell.
* Add a 'cell' entry to config/cells.yml
 * Say how it should be displayed, and what it's classification is
 * Add any parameters you want to render here (constants for instance)

You can arbitrarily render additional templates if you need to by hitting the /cell/NAME/ACTION endpoint. Name is the name of the cell, action is the name of the .erb file.

## Under the hood

Zygote is powered by the GenesisReactor, which is an event machine driven framework.

But, you probably don't have to care about that. You just need to know asynchronous actions are available to you.

# Testing

Tested automatically using [travis ci](https://travis-ci.org/dalehamel/zygote).

Most tests are fixture based, as the app primarily renders templates.

To regenerate fixtures, set FIXTURE\_RECORD=true before running test.
