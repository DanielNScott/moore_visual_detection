## Project notes ##

### Experimental details ###
Experimental design aims:
- produce as many at-threshold samples as feasible
- produce enough max stim and no stim samples as necessary to validate performance
- produce enough max stim samples to keep mice engaged
- use the smallest possible number of amplitude bins to maximize samples per bin
- we want to maximize number of trials and mice 
- want full time on rig, i.e. 12 hours, yielding 400-500 trials
- don't want active air puff, too much over-use of the same (facial) sensory areas
- want to start with max stim. until d' of 1.2 and then start adding in threshold
- uniform depth sampling every 50 microns from 100-350, counterbalanced for days by mice
- Sampling should be 6-8 planes for 30 days, 5 planes per mouse per day per depth
- Want piezo amp calibrated, converted to [mm], and to know velocity

Additional?
- repeat samples vs pseudo-populations?

### Behavioral expectations ###
We expect each mouse should:
- behave more poorly, abruptly, when threshold stim is added
- climb over the few days following threshold addition
- be able to perform as many as 700-1000 trials in a session properly (hence 500 should be fine)
- take 2 - 14 days to display stable d' > criterion task performance (for max sim, expect 3-4 days)
- quickly acquire indiscriminate responding, then lower FA rate to asymptote (14 - 17 days to FA asymptote)
- increased time out (15s to 20s) might change the FA asymptote speed to be faster
- have few lapses of valid responding within a trial, compared to early or late performance fall off
- have a detection threshold of approximately [...]
- have fairly consistent trial-by-trial and day-by-day psychometric functions
- have increasing(?) uncorrected-for-FA thresholds
- have consistent or slowly decreasing corrected-for-FA thresholds
- have body weight that doesn't co-fluctuate with performance
- lick more over days and trials while learning
- lick closer to first stim while learning
- licking and running should have some reward modulation

### Behavioral analyses ###
- Plot d', hits, misses, FA, and CR for each session should show high d', high max stim hits 
- Plot d', hits, misses, FA, and CR for statistics over sessions, which should show early drift followed by steady by-session behavior, possibly with decreasing by-session variance over time.
- Plot corrected and uncorrected psychometric functions over days and within session.
- Plot first lick onset by by day, PSTH of licking by and within days
- Plot running and licking rates vs reward rate

### Neural expectations ###
1. Average PV cell responses are related to behavior during the sensory period
   1. ~20-40% of PV interneurons in L2/3 will show significantly different averages conditional on detection.
   2. ~70% of these will be "hit" neurons
   3. ~25% of stim responsive (SP high) PY neurons will show DP high (i.e. hits) and no misses
   4. Per Hyeyoung the grnsFS exist, and so maybe we'll see PVs which are DP significant and non SP significant
2. (Deister) Hit and miss cells are correlated by assembly
3. (Larkum? SOM?) Cell signal and detect probabilities should change over trial time
4. (per our prev work) Higher corrs in PVs than PYs, roughly 0.4
4. (Hansen) We expect correlations to be ~0.26 between PYs in L2/3 or L5/6 and ~0 in L4
5. Motor (licking) behavior should modulate cells during wait and reward period more than stim periods
6. We expect significant noise correlations between interneurons
   1. On the basis of connectivity - distance dependent?
   2. On the basis of prior findings
   3. There should be a large principal component in the all-on dimension
7. Some fraction of PY & PV cells should show parametric modulation by stimulus amplitude (neurometric)
- hit predictive cells more superficial because of top down connectivity dropping into layer 2/3

### Neural analyses ###
- classify all cells as hit/miss, fa/cr, stim, reward, lick, run modulated
- fit recurrent GLM (ms-wise and epoch-wise) to get functional connectivity
- examine both explained and unexplained variance in terms of noise correlations.
- spontaneous activity during the inter-trial period

### Novel hypotheses ###

1. Depth will affect modulation by hit and miss, fa, cr
   1. (?) There may be differences in modulation by depth
-  SP should be more significant deeper, DP time course might be laminar based on inputs hitting top first
2. PV-PY cross modes should be more closely related to performance than either alone.
3. PY-PV cross mode substructure should reveal consistent ensembles
4. Learning (reduction of FA rate over time) should suppress early DP neurons decorrelated with SP such that population variance increasingly favors those correlated with SP.
5. By-day sequential effects should indicate changes in noise variance along SP and DP dimensions
6. Total correlation should change over trial time to reflect "setting dynamics" in recurrent computation
   1. These dynamics should differentiate between choices (lick vs. no lick)
   2. These dynamics should shift from purely reflecting DP to reflecting DP and SP
7. A simple neural network model with L2/3 and L4 should exhibit our hypotheses while performing the task
noise corrs during inter trial interval have some significant relation to the ensembles during task performance

### Controls ###
Regarding behavioral expectations:


### Results ###


