# moore_visual_detection

----------------------------------------------------\
% Notes from November 19th Meeting

Ian added noise correlation code for pairwise cells

Dan added the signal correlation and NC x SC

Ian will run rSignal, rNoise, OSI across data set

Dan will work with correlations on one session
- we will use github

----------------------------------------------------
% Notes from December 2nd 2020 Meeting

Days 1-7 learning - Ian will code NC VS SC for first 
and last day 

Clustering through different learning mechanisms
- eigenvalues clusters change with learning

Contrast involved - Dan will implement contrast as 
opposed to orientation 

Hit Miss CR FA - we should analyze data in terms of 
these trial types

Behavior GitHub script -  Ian will add code to parse 
the behavior

Upcoming Analyses = 
- Neurometric Function
- Psychometric Function

Contrast Bins ~ 1-5, 10-30, 50-100

----------------------------------------------------
% Notes from December 8th 2020 Meeting

Added behavioral code for parsing hit and miss data 

Noise correlation of hit and miss cells and OSI

Dan is going to add contrast 
- compare learning of contrast vs. orientation
- psychometric function

Ian will pull slope and intercept of NCxSC plots over
the data set

----------------------------------------------------
% Notes from January 14th 2021 Meeting

Ian added code for neurometric and psychometric functions
- neurometric functions are going to be changed to be z scored

Dan is looking at the trial cross correlation instead of mean

We are going to add SC x NC across each days of training

Ian is working on getting all data to the cluster
- the current data set does not have all days in a row
- current data is pulled from sessions with 100 trials

----------------------------------------------------
% Notes from January 18th 2021 Meeting with Chris M and Chris M

Moore Project 21-18-12 (yy-mm-dd)

Attendance:
- Ian More (IM), Chris Moore (CM), Chris Deister (CD), Dan Scott (DS)

Topics discussed:
- Autocorr, xcorr, and multitaper indications of ~12.5 Hz power peak
- Decreasing slopes and increasing intercepts of the signal to noise relationships
- Xcorr noise correlation as a (not very informative) noise correlation metric to be used alongside total evoked NC.
- PSTH piecewise linear fit

Commentary from CD, CM:
- PV cells with this gcamp are in bottom of fluorescence-by-CA concentration curve, so indicator not very sensitive
- Distribution of flourescence gets skewed by activity - different distributions for different mean rates
- This is because the PV cells are heavily calcium buffered
- Usually ranking of activity values is used to give baseline between 10 and 15th percentile of fluorescence

Suggestions:
- Consider high-pass filtering the data as part of the baselining procedure
- Apply OASIS (deconvolution / spike inference) and look to see what it's doing to baseline as well.
- Look at different baselining procedures for various asymptotic exemplars of the data to see how they compare
- Two asymptotic exemplar timeseries to be sure to compare with is neuropil ROI and average over such ROIs
- Would hope that somatic rhythmicity would not show up in neuropil if it is not of nuisance physiological origin
- Heart rate might give ~12 Hz
- Check out original gcamp 6 paper to see how they're baselining
- Check out fig 4 of Hyeyoung's paper from last year

Additional:
- In prev. discussion IM says Hyeyoung's work found higher baseline activity in detect trials
- Noted that higher beta gives more non-detection in CM & Stephanie Jones' work
- CM work indicates more gamma implies less detection
