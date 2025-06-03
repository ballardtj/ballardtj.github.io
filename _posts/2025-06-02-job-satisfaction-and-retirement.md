---
layout: single
toc: true
title: "Life After Work: What are the Key Drivers of Decisions to Retire?"
date: 2025-06-02
categories:
  - Blog
tags:
  - Retirement
  - Job Satisfaction
  - Physical Health
  - Mental Health
  - Ageing Workforce
  - Employee Retention
  - People Analytics
  - HILDA Survey
header:
  teaser: /assets/images/9_retirement_factors_plot.png
  og_image: /assets/images/9_retirement_factors_plot.png
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

As Australia's workforce steadily ages, forecasting retirement becomes increasingly important for strategic planning. Many organisations grapple with predicting when experienced employees might decide to leave, a decision often influenced by a range of personal and professional factors. [A recent report by the Australian Treasury highlights the economic implications of an ageing population and changing retirement patterns](https://treasury.gov.au/publication/2023-intergenerational-report), demonstrating the need for businesses to adapt. But what truly tips the balance for older workers considering retirement – is it declining health, waning job satisfaction, or something else entirely?

## Navigating the Path to Retirement: What the Data Show

We explored this question using data from the Household, Income, and Labour Dynamics in Australia (HILDA) survey, a long-term study of life in Australia. Our analysis focused on 3,487 participants aged over 60, tracked from as early as 2001. We used a generalised linear mixed model to predict the probability of an employee retiring in the subsequent year, based on their mental health, physical health, and job satisfaction. The model also controlled for the type of occupation, their gender, and their age, allowing us to better isolate the effects of these key wellbeing and satisfaction factors.

The graph below illustrates the predicted chance of retirement (vertical axis, expressed as a percentage) across different levels of job satisfaction, mental health, and physical health (horizontal axis, representing standardised scores from -2 to +2, where 0 is the average). Each line represents the trend for one of these factors, holding others constant. If you squint, you might be able to see the 95% confidence interval shown as a ribbon around each line. This dataset is huge, so the error is small. 

![](/assets/images/9_retirement_factors_plot.png)

Several patterns emerged. First, **job satisfaction** stands out as the strongest predictor of retirement decisions. As shown by the green line, higher job satisfaction is associated with a lower probability of retirement. Our analysis indicates that for each standard deviation increase in job satisfaction, the odds of retiring decrease by approximately 15.3%. This effect is notably stronger than that observed for physical or mental health, emphasising the impact of a fulfilling work experience on the decision to continue working. It suggests that employees who feel genuinely content and valued in their roles are much more inclined to postpone retirement, more so than due to health factors alone. This aligns with [other findings](https://ballardtj.github.io/blog/wages-vs-satisfaction/) that enjoyable work and a positive workplace environment are powerful retention factors. This is true even for those approaching traditional retirement age.

Secondly, **physical health** also influences retirement decisions, as depicted by the red line. Better physical health is associated with a lower likelihood of retiring. Specifically, for each standard deviation improvement in physical health, the odds of an employee retiring decrease by about 6%. This is makes sense. Individuals in good physical health may feel more capable of continuing to work and may not be pushed into retirement due to health limitations. [Research shows that poor health is a key driver of decisions to retire](https://doi.org/10.1016/j.ssmph.2019.100514).

The role of **mental health**, shown by the blue line, presents a more complicated picture. Our findings suggest that better mental health is associated with a slightly *higher* probability of retirement. For each standard deviation increase in mental health score, the odds of retiring increase by approximately 7.9%. This might initially seem counterintuitive. One interpretation is that individuals with good mental wellbeing feel more confident, resourceful, and prepared to embrace the transition to retirement as a positive life stage. Another perspective is that the anticipation of impending retirement itself may contribute to improved mental health in the lead-up to leaving the workforce.

## Creating a Supportive Environment for an Ageing Workforce

These findings offer useful insights for organisations seeking to manage an ageing workforce effectively and support employees as they approach retirement.

Given that job satisfaction emerges as the most potent factor, organisations should actively prioritise job satisfaction among older workers. This goes beyond superficial perks. It involves ensuring roles are meaningful, providing appropriate levels of challenge and autonomy, recognising contributions, and fostering a respectful and inclusive culture. Investing in the work experience of mature-aged employees can be a highly effective strategy for retaining their valuable skills and experience for longer.

The clear link between better physical health and delayed retirement demonstrates the importance of supporting the physical wellbeing of employees nearing the traditional retirement age, particularly for those who wish to continue working. This doesn't mean attempting to prevent retirement, but rather enabling those individuals to continue contributing effectively if they choose. This could involve ergonomic adjustments, flexible work arrangements, or re-designing roles to accommodate their needs. Offering options like phased retirement, part-time schedules, or consultancy roles can be particularly beneficial, allowing employees to reduce their hours or change their work type in line with their physical capacity, while the organisation continues to benefit from their expertise.

Finally, organisations should embrace and facilitate positive retirement transitions. The finding that those with better mental health might be more inclined to retire suggests that retirement is often a proactive choice made by individuals who feel ready for a new chapter. Rather than viewing retirement solely as a loss of talent, organisations can foster a culture where this transition is seen as a natural and positive progression. Supporting employees in planning for retirement, celebrating their careers, and maintaining connections through alumni programs or mentoring opportunities can make the process smoother and more positive for everyone involved. This approach acknowledges the individual's journey while also facilitating better knowledge transfer and succession planning for the business.

## Next Steps

The decision to retire is different for everyone. While job satisfaction appears to be the most significant lever for retention among older workers, physical health also plays a key role in enabling continued work. Understanding these dynamics is key to retaining valuable experienced staff and supporting positive transitions when employees do decide to retire.

Want to explore how factors like health and job satisfaction are influencing retirement patterns in your organisation? I specialise in applying advanced analytics to workforce data, which can help organisations develop evidence-based strategies for managing an ageing workforce.

[Get in touch](mailto:t.ballard@uq.edu.au) to discuss how we can apply these analytical approaches to your organisation's unique challenges related to retirement planning and older worker engagement.