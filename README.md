# multi-platform-ntp-one-recipe

This is an example Chef cookbook for configuring a simple service, NTP, accross two different platforms: Red Hat and AIX

In this example, just the default recipe is used to create the logic required to allow the cookbook to run on the two platforms, and achieve the task of configuring NTP properly on each one.

With the relatively simple setup we are testing here, a single default recipe isn't too bad. However, even with NTP things can get more complicated.  For instance, in this example, Red Hat releases have differnet providers.  RHEL 6 will use ntpd, while RHEL 7 will use chrony.  This adds a bit more obfuscation of purpose to the human readable aspect of the code.  While there is a lot to be said for succinctness, we also want to make it easy for others to modify our stuff when we aren't around.

So, you see the code can become garbled and hardish to read fairly quickly.  To avoid that, it's sometimes better to use a different pattern. One such pattern could be:

* recipes/default.rb -> identify OS platform and call another recipe based on that
* recipes/aix.rb - called from default.rb on AIX nodes
* recipes/redhat.rb - called from default.rb on Red Hat nodes
* recipes/xxx.rb - called from default.rb on XXX nodes

I will also be creating an example of that cookbook pattern, and will link it here when it is complete.
