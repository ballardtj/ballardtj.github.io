---
layout: single
toc: true
title: "How Can We Improve Fatigue Forecasting in Safety Critical Industries?"
date: 2024-10-24
categories:
  - Blog
tags:
  - Fatigue Forecasting
  - Biomathematical Models
  - Occupatational Health & Safety
output: 
  md_document:
    variant: gfm
    preserve_yaml: true
    
---


<style>
  body {
    font-size: 0.8em; /* Adjust font size just for this page */
  }
</style>

## Biomathematical Models of Fatigue ##

Fatigue management in safety critical work environments is a big issue. Industries like mining, 
aviation, healthcare, and defense all involve operations that require crew to be working around the clock. 
And the cost of human error in these environments can be catastrophic. Mistakes can lead
to loss of life and have huge financial and societal repercussions. The terms **safety critical**
or **high reliability** are both often used to describe these types of operations.

Give the around-the-clock nature of the work in these industries and potential for fatigue-related 
performance impairment to have such severe consequences, there's a clear need for fatigue forecasting.
The dominant approach to fatigue forecasting is to use what are called *biomathematical models* of fatigue.
Biomathematical models are used to predict an operator's fatigue based on a number of factors, the most
important of them being sleep history and time of day. The figure below shows one of the oldest biomathematical model--the two process model--
which is still among the most widely used. This model assumes that fatigue is determined by two factors: sleep history and time of day. 
Sleep history is governed by the **homeostatic** process. Quite simply, fatigue increases when you’re awake and decreases when you sleep. 
In theory, fatigue could change at different rates for different individuals, which is what these different lines represent.
Some folks might feel completely restored after 6 hours sleep whereas others might need 9 or 10 to feel
completely recovered. 

![](/assets/images/2024-10-24-fatigue-modelling_files/s_and_c_processes.png)

The second factor, time of day, influences the circadian process. There can be individual 
differences in this too. Some people’s circadian rhythm might peak later in the evening (e.g., the 
proverbial night owl) while others might peak earlier in the afternoon. According to most biomathematical
models, the sum the circadian and homeostatic process determines the operator's fatigue.
Importantly, however, when you consider that individual differences very likely exist in the homeostatic process
**and** the circadian process, it's clear that these models don't make a one-size-fits-all forecast.
In fact, there's a huge amount of variability in possible fatigue trajectories across the workforce. This is where things get tricky.

## Fatigue Risk Management Software ##

Biomathematical models are widely used in practice. They inform the algorithm underlying fatigue risk management software programs
like SAFTE-FAST, FAID, etc. These are proprietary platforms that are used heavily in industry to manage shiftwork. Managers use
these platforms to simulate the fatigue patterns of shift workers based on the times of day they'll be working, how long their shift lasts, 
when they'll likely be sleeping, and how much sleep they're likely to get. Managers can then use this information to design rosters that ensure
the risk of fatigue-related performance impairment is at a minimum. This approach has merit. An advantage of these tools is that they
make precise, quantitativepredictions about how fatigue should change over time that are directly actionable by managers designing shiftwork.
These models are also biologically inspired. The mathematical functions that underpin the model have been developed based on biological processes
that actually control fatigue. Hence, there's a fair amount of academic research to support these models.

The problem, however, is that these fatigue risk management platforms too often generate one-size-fits-all predictions 
that fail to account for diversity of the workforce. Instead, they rely strong assumptions about how the homestatic and circadian processes
operate that are based on so-called "default" parameter values. And in many cases, it's not at all clear where these assumptions come from.
These parameters that determine, for example, the rate of change in fatigue, or the timing of the circadian peak--there are a whole range of 
theoretically plausible values for these parameters. How were these parameters chosen?

Typically, when validating mathematical models of human data, analysts would do what's called *estimating the model parameters from the data*. 
Instead of imposing strong assumptions about particular parameters, analysts would identity parameters that have uncertain values and/or
could plausibly vary across individuals and treat these as unknown quantities. They would then use the data to inform their understanding
of these quantities. In this way, they learn from the data. The resulting parameter estimates, now informed by the data, enable predictions
to be made about fatigue trajectories that are tailored to the population whose fatigue they want to predict. Ultimately, this use of data-informed
parameters allows for more accurate forecasts to be made, which translates into more effective fatigue management practices.

## Where Do Default Parameters Come From? ##

So how much of a problem is it when software applications use standard, "default" parameters to generate fatigue predictions instead of parameters
that have been learned or informed from data. To answer this question, we need to understand where these default parameters come from. 
In the biomathematical modelling academic literature, it's common to see papers that rely on these default parameters, instead of using their data
to provide more informed parameter estimates. Here are excerpts from a few papers that do so. But very few papers actually communicate where the 
values come from. 

As it turns out, these default values are based on a small set of very underpowered studies from the 80s. [One study by Akerstadt and Gillburg](https://pubmed.ncbi.nlm.nih.gov/7256076/) that's commonly cited as generating the default values used in a great deal of subsequent research used just 6 participants.
[Another such study by Borbely and colleagues](https://pubmed.ncbi.nlm.nih.gov/6165548/) used 8 participants. These studies also collected data from participants for only up to two days. Now
to be fair, these studies aren't at fault. They couldn't have known that the parameter values they published back in the 80s would end up being
used to heavily in the decades that followed. These were sleep deprivation studies that brought participants into the lab for two whole days,
prevented them from sleeping, and then examined the effects of participants' fatigue on a range of different things. This was expensive and time consuming
research and, especially in the 80s, there's no reason why they might have used more participants or kept participants in the lab for longer than two days.
Still, there are important questions that need to be asked about whether assumptions about key parameter values from this early research can be used
to generate valid forecasts for fatigue trajectories over weeks or even months for a wide array of different types of workers. 

## Comparing Predictions of Default Values to Data-Informed Parameters ##

My team and I worked with the Australian Navy to answer some of these questions. We tracked crew member sleep and wake times, and their fatigue levels, 
over the course of several one-to-two week undersea operations. We then used two versions of a biomathematical model to predict crew member fatigue levels.
In the first version, we applied a standard biomathematical model using the default values. Here, we just estimated a single noise parameter that 
represented the uncertainty associated with the fatigue estimate. In the second version, we applied a model in which all parameters were estimated. 
This model therefore allowed for individual differences in these homeostatic and circadian processes--processes that, again, should theoretically differ 
across individuals.

The graphs below shows the results. The dots are the observed fatigue levels that crew members reported. The black line is the model prediction 
and the blue ribbon is the uncertainty associated with the model prediction. The panels represent the different shifts, but the differences between 
those aren’t particularly important. We just need to parse those out in order to see the predictions clearly. As can be seen, the default value model
does a terrible job at predicting fatigue. It basically predicts a flat line, which usually means that there are individual differences that are cancelling out. 
So the models’ response to this is to treat things as really uncertain--so uncertain that the prediction is essentially useless. The model with data-informed parameters
is **much** more accurate, not only in terms of the overall prediction (i.e., the alignment between the black dots and the black lines), but also in terms
of the precision of this prediction (i.e., the fact that the blue uncertainty ribbons are so narrow). This means the second model is making the
correct forecast, and it's doing so with a high degree of confidence.

![](/assets/images/2024-10-24-fatigue-modelling_files/model_fits.jpg)

Of course, you could argue that, the model with data-informed parameters is always going to make more accurate predictions because the very same data was used to inform the model's parameters. 
This is true. It's not a suprise that the second model does a better job. What is suprising, however, is **how much better** a job the data-informed model does
than the default value model. This default value model is not a strawman. It's not obvious that this model should make such poor predictions. After all, it forms the 
basis of the software platforms that are being used to manage shift work in industry. The surprise is just how much better off an organisation can be if they move beyond
these off-the-shelf platforms and develop costumised solutions for forecasting and management fatigue among their workforce.

As part of a project led by Dr Micah Wilson, my team developed an R package called the *Fatigue Impairment Performance Suite* (FIPS) that lets the user
apply different assumptions about the key parameter values, so that shiftwork managers and other practioners can see how the fatigue forecasts change
as assumptions change. But if your organisation has their own fatigue data, we can help you go a step further. We can deliver a custom platform for forecasting 
fatigue that is tailored to your workforce. (end another sentence)







