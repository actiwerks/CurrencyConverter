# CurrencyConverter
Example implementation of minimalistic online currency converter for iOS with plugin online conversion API using Swift 
programming lanuague.

You can download the corresponding iOS application from the App Store using this link : 

<a href="https://itunes.apple.com/us/app/convcurrency/id1337200486" rel="some text">![Foo](./AppStore.svg)</a>

User can choose both source and target currency as well as desired date, conversion rate is based on online data 
available from https://api.fixer.io/  (European Bank) but it is easy to replace this with any other online currency table
(see Conversion.swift for details).

UI is deliberately minimalistic and should work both in portrait and landscape mode. UI design doesn't require any localised 
strings (besides currency names fetched from the conversion API) so application should work for international users out of the box.

Network connection is required at least once (to load the latest conversion rates), should at any time the conversion rate fetching 
for any historical date fail, the stored conversion rates are used instead. This fact is communicated to the used by dimming 
and blurring the date button slightly. 

Network requests are handled using popular Alamofire framework (https://github.com/Alamofire/Alamofire), 
integrated via CocoaPods (https://cocoapods.org). If you need help with configuring these, consult their documentation.

Any comments, suggestions, ideas etc. welcome.

