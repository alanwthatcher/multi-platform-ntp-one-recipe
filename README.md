# multi-platform-ntp-one-recipe

This is an example Chef cookbook for configuring a simple service, NTP, accross two different platforms: Red Hat and AIX

In this example, just the default recipe is used to create the logic required to allow the cookbook to run on the two platforms, and achieve the task of configuring NTP properly on each one.

With the relatively simple setup we are testing here, a single default recipe isn't too bad. However, even with NTP things can get more complicated.  [For instance](https://github.com/alanwthatcher/multi-platform-ntp-one-recipe/tree/more-complex), with Red Hat, you may have different implimentations of the NTP serivce (ntpd and chrony) based on the version of RHEL you are running.  In that case, the differences aren't just with the platforms, but between versions within the same OS platform.

So, you see the code can become garbled and hardish to read fairly quickly.  To avoid that, it's sometimes better to use a different pattern. Such as:

* recipes/default.rb -> identify OS platform and call another recipe based on that
* recipes/aix.rb - called from default.rb on AIX nodes
* recipes/redhat.rb - called form default.rb on Red Hat nodes
* recipes/xxx.rb - called from default.rb on XXX nodes

I will create an example of that, and link it here.
