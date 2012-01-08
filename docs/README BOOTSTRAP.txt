12-28-2011

I have tried tree different approaches
-----------------------------------------
clean less code updating 
fail on compiling unless i modify fit bootstrap code, which defeat to whole thing about letting twitter maintain the bootstrap code

-----------------------------------------
using the less-rails-bootstrap gem
the less-rails-bootstrap gem can import all css so I don't have to add the css files, 
I still have to add the javascripts.
I can use both less and scss in the same application or switch the entire app to less.

I tried both but ended up by being unable to modify/read the color mixin for bootstrap directly, beeing unable ot modify is ok
If I want to override add colors in the application.css file It's hard to do it with a partial.

-----------------------------------------
compass_twitter_bootstrap
all the same as less-rails-bootstrap



-----------------------------------------
I ended up with 'simple is better'
all i did was to add the bootstrap.css file and the javascripts, then i only rely on twitter and nothing happens automatic in the background

