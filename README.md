# ML4iOS

The idea of this project is to create a very simple open source
library to help developers to integrate Machine Learning on any 
iOS application.

To implement this library I have used a powerful and innovative
platform named [BigML](https://bigml.com). This platform provides 
the funcionality necessary to handle easily resources such as data 
sources, datasets, models and predictions.

This library is licensed under the
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

## Usage

To use this library there are two main options:

1) Add the source code to your project 

2) Generate the library and add to your project the generate file ML4iOS.a. 
Also don't forget to add to your project the header files placed in the include folder.

I have included three .csv example files under the data folder of the testing application.

## Testing

The project ML4iOSTests implements a test case that shows a basic usage of the library.
It creates a data source from a sample .csv file. Once the data source is created it is
created a dataset from the data source, a model from the dataset and a prediction based
on the model created.

## Support

If you find any bug or issue please report it to me on
[ML4iOS issue tracker](https://github.com/fgarcialainez/ml4ios/issues)

If you have any question, doubt or problem with the API feel free
to [contact](https://bigml.com/developers/support) them. They provide
very good support for developers.

## Requirements

Requires iOS 5.0 and later.

In order to use the library you need to have a BigML account. You can apply
for an invitation on their web site.

## Contributing

Please feel free to contribute to this library. My idea was 
to publish it under Apache License in order to allow that anybody
interested can contribute to the project. I am sure that it could 
help to a lot of iOS developers that want to integrate Machine
Learning functionalities on their applications.

The recommended steps to follow for any contribution are:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
