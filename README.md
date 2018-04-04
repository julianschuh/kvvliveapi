# kvvliveapi for Ruby
This repository contains the `kvvliveapi` Gem which provides Ruby bindings for the KVV (Karlsruher Verkehrsverbund) Live API as used on the KVV's website.

The Gem is based on the [Python bindings](https://github.com/Nervengift/kvvliveapi) as documented by [Nervengift](https://github.com/Nervengift). For further information about the inner workings of the API consult the [Python bindings](https://github.com/Nervengift/kvvliveapi) repository.

## Usage and Installation
The API is very easy to use if you have a working Ruby development environment.

### Installation
Install the Gem with `gem install kvvliveapi`.

### Examples
```
irb(main):001:0> require 'kvvliveapi'
=> true
irb(main):002:0> KVVLiveAPI.stops_by_name('Barbarossaplatz')
=> [#<KVVLiveAPI::Stop:0x00007fa97baf6780 @name="Karlsruhe Barbarossaplatz", @stop_id="de:8212:5003", @lat=48.9949189, @lon=8.38931904>, …]
irb(main):003:0> _.first.to_s
=> "Karlsruhe Barbarossaplatz(de:8212:5003)"
irb(main):004:0> KVVLiveAPI.stops_by_coordinates(48.995091, 8.390642)
=> [#<KVVLiveAPI::Stop:0x00007fa97bace3e8 @name="Karlsruhe Barbarossaplatz", …>, …]
irb(main):005:0> KVVLiveAPI.stops_by_id('de:8212:5003')
=> [#<KVVLiveAPI::Stop:0x00007fa97bab4920 @name="Karlsruhe Barbarossaplatz", …>]
irb(main):006:0> KVVLiveAPI.depatures_by_stop('de:8212:5003')
=> [#<KVVLiveAPI::Departure:0x00007fa97b9eb020 @route="2", @destination="Wolfartsweier", @direction="2", @lowfloor=true, @realtime=true, @traction=0, @time=2018-04-04 19:29:21 UTC, @stop_position="2">, …]
irb(main):007:0> KVVLiveAPI.depatures_by_route('2', 'de:8212:5003')
=> [#<KVVLiveAPI::Departure:0x00007fa97d831840 @route="2", …>, …]
irb(main):008:0> _.first.to_s
=> "2 (-> Wolfartsweier) @ 21:49, Stop 2"
```