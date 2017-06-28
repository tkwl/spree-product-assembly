# Product Assembly

[![Build Status](https://travis-ci.org/spree-contrib/spree-product-assembly.svg?branch=master)](https://travis-ci.org/spree-contrib/spree-product-assembly)
[![Code Climate](https://codeclimate.com/github/spree-contrib/spree-product-assembly/badges/gpa.svg)](https://codeclimate.com/github/spree-contrib/spree-product-assembly)

Create a product which is composed of other products.

---

## Installation

Add the following line to your `Gemfile`
```ruby
gem 'spree_product_assembly', github: 'spree-contrib/spree-product-assembly', branch: 'master'
```

Run bundle install as well as the extension install command to copy and run migrations and append spree_product_assembly to your JS manifest file.

    bundle install
    rails g spree_product_assembly:install

_master branch is compatible with spree edge and rails 4 only. Please use
2-0-stable for Spree 2.0.x or 1-3-stable branch for Spree 1.3.x compatibility_

_In case you're upgrading from 1-3-stable of this extension you might want to run a
rake task which assigns a line item to your previous inventory units from bundle
products. That is so you have a better view on the current backend UI and avoid
exceptions. No need to run this task if you're not upgrading from product assembly
1-3-stable_

    rake spree_product_assembly:upgrade

---

## Use

To build a bundle (assembly product) you'd need to first check the "Can be part" flag on each product you want to be part of the bundle. Then create a product and add parts to it. By doing that you're making that product an assembly.

The store will treat assemblies a bit different than regular products on checkout.
Spree will create and track inventory units for its parts rather than for the product itself.
That means you essentially have a product composed of other products. From a customer perspective it's like they are paying a single amount for a collection of products.


---

## Contributing

See corresponding [guidelines][1].

---

Copyright (c) 2007-2015 [Spree Commerce Inc.][2] and [contributors][3], released under the [New BSD License][4]

[1]: http://guides.spreecommerce.com/developer/contributing.html
[2]: https://github.com/spree
[3]: https://github.com/spree-contrib/spree-product-assembly/graphs/contributors
[4]: https://github.com/spree-contrib/spree-product-assembly/blob/master/LICENSE.md
