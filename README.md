# Thank you for taking the time to do this!

The purpose of this challenge is to implement a part of an ad delivery system. Since this is a code challenge, we're not interested in the system actually delivering video ads -- we just want to see how you approach writing code and solving problems.

Regarding the language, you should use whatever language you feel most proficient on. We care that you're confortable and are in an environment where you can give your best so choose whichever language you want, of whatever paradigm. And remember that this is your moment to shine. Consider your decisions carefully and pay attention to the quality of what you deliver -- impress us.

## How we deliver ads (roughly...)

As you know, we serve adverts on various websites. When serving these adverts, there are various constraints that affect which ones we choose to serve. One part of our codebase evaluates the available ads for a given request.

Here's how it goes:

- When we get a request, we know where this ad is embedded - we call this the channel, and it could be a news site, a cooking blog, fashion or travelling website, etc.
- Similarly, we have always several ads we can display, each with a bunch of constraints (e.g. we only run German speaking ads in Germany, we only show cooking ads in cooking channels, we only show fashion ads if a channel indicates in a request that this is one of the preferences of the end user)
- A single ad can only be served for a certain amount of time -- it always has a start date and an end date.
- Ads have also a limit of views. Each ad has a limit, but some channels have lower limits (e.g. we can display the new Nike ad 5000 times, but only 50 times on, for instance, the New York Times blog)

So for each request, we want to return a suitable ad. If more than one ad is suitable, then we can return any of the suitable ads. If there are no suitable ads, we will not provide an ad.

## Your Challenge

- Implement a prototype of this ad-request-to-ad matching mechanism that can serve ads;
- The request may be for a specific ad id, or may be just asking for available ads;
- The request contains a reference of which channel is sending it;
- There is other information in the ad-request, which will be used to discriminate which ad to show (country, language, interests that the user may have defined in the channel, etc).

## What we care about

Since this is a prototype we don't actually care about real ads or campaigns -- the data you use should be completely mocked and can always be in memory.

Here's what we do care about:

- The code -- this challenge is for us to get an idea of how you approach writing code and solving problems;
- The reasons behind your technical decisions -- it's important that you're ready to explain them since we'll be going through your solution in detail;
- That the we always get suitable ads according to the constraints -- how are you sure that your code does what you think it does?
- What questions you'll ask -- it's more than ok to drop us a line or even give us a call on skype if you have questions or want to discuss some approach with us. We are happy to discuss the problem with you, make something more clear in case it's not or discuss solutions;
- Finally, that we are able to run your application without having to ask you questions over email. Make use of the README file, and be especially verbose if you're going to use Windows -- we're mostly Linux and Mac users in RPM.

:-)

Hoping you have fun,
Red Pineapple Media Engineering Team
