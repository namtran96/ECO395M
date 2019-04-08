Green Buildings Revisited
-------------------------

In this report, we revisit the greenbuildings data we previously used to
practice data visualization. However, with our new toolkits, we will try
to:

-   Build the best predicitve model we can for average rent

-   Quantify the green rating coefficient

-   See if this coefficient is different for various types of buildings

Next we begin by selecting our models. I have elected to use stepwise
regressions to hopefully create a more accurate model. I utilize
"Forward Selection", "Backward Selection", and "Stepwise/Both."
Additionally, I opted for a log-linear model to capture the effects of
green ratings on rent in terms of percentages. I find this to be more
intuitive and easy both understand and visualize.

### Results

After running these different types of regressions over the data, we
find a couple of interesting findings. We find that the forward and
stepwise selection end up with the same model, and secondly, we see that
the green rating coefficient is positive across the models.

    models_coefficients 

    ##                Model green_rating_estimate
    ## 1  Forward Selection            0.02906547
    ## 2 Backward Selection            0.02953035
    ## 3               Both            0.02906547

Based on these regressions on the entire dataset, we summise that a
green rating certification will yield almost a 3% increase in average
rent, holding all else fixed.

Next, we look try to see if this green rating effect will differ across
different types of buildings. I will try to find the effects for
different buildings class/quality as well as different ages. To achieve
the former, I use the pre-defined building classes in the data set. For
the latter, I subsetted the data into different age quantiles. I then
ran the three different types of stepwise regression for each data
subset, and here are the results.

    class_coefficients 

    ##                Model green_rating_a green_rating_b green_rating_c
    ## 1  Forward Selection     0.01593431     0.06199907             NA
    ## 2 Backward Selection     0.01646874     0.05800449             NA
    ## 3               Both     0.01593431     0.06199907             NA

For the class coefficients, We first note that green ratings were not
used in the final regressions for buildings with class C. This can be
attributed to class type, as class c buildings are at the low-end and
least desirable. Thus, they are unlikely to qualify for green ratings.
Secondly, within the classes, we see relatively large coeffficients for
buildings of class b. These buildings are deemed reasonable quality and
only a notch down for the high-quality properties of class a. Perhaps
green ratings are one of the easier ways for a reasonable quality
building to improve their overall aesthetics without massive overhauls.
Now, we will look at the different effects for different aged buildings.

    median_age

    ##   Age_quantile Median
    ## 1            1     17
    ## 2            2     24
    ## 3            3     34
    ## 4            4     64
    ## 5            5     98

    age_coefficients

    ##                Model green_rating_1 green_rating_2 green_rating_3
    ## 1  Forward Selection     0.02607253     0.02393705             NA
    ## 2 Backward Selection     0.02382768     0.02227753             NA
    ## 3               Both     0.02607253     0.02393705             NA
    ##   green_rating_4 green_rating_5
    ## 1             NA             NA
    ## 2             NA             NA
    ## 3             NA             NA

When we look at the age coefficients, we see a larger effect in the
young buildings or quantile 1 which has a median age of 14. Green rating
coefficients are still siginificant, although just slightly smaller in
magnitude for the second quantile which has median age of 24. And for
the last three quantiles we see that the green ratings wre insignificant
and thus not included in the final model. This is expected as antiquated
buildings would likely be unable to attain green certifications.

What causes what?
-----------------

1.  This would largely be ineffective as you would simply jsut be
    finding correlation between the two statistics, and as we all know
    correlation is not causation. Additionally, there are many exogenous
    variables being ommitted that would affect the regression from city
    to city. Whether they arestate laws or cultural phenomenas, we would
    be missing a large portion of explanatory powers.

2.  Initially, the UPenn researchers were searching for ways to have an
    increased police presence without it being related to street crimes.
    They finally were able to isolate this effect by utilizing the
    terror alert system in Washington D.C. On "Orange Alert Days"" of
    the terror alert system, there would be extra police out in the
    city, largely to prevent terrorism. This enables them to ask," On
    these days, what happens to street crimes with the increased police
    presence unrelated to street crimes?." The results say that there
    are decrease in street crimes such as murder, robbery, assault etc.

3.  One of the theories weakening the prior result was whether the
    civilian population were just not as active on these days. To look
    at this phenomena, the researchers controlled for Metro ridership to
    capture whether tourism in the city was lower on the "Orange Alert
    Days." They found that there was no effect on tourism from the
    terror alerts.

4.  The model here is using interation effects of high alert days and
    districts in Washington D.C. The researchers are looking whether the
    decrease in crime is equal across the city or concentrated in a
    particular district. In this case, they found that the decreases
    were concentrated at in District 1 which contains the National Mall.
