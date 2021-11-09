# Project & code details #

## File / folder organization ##
The folder hierarchy is:
- analy - data analysis functions
- clust - cluster utilities such as submission scripts
- data - storage folder, unversioned except for ms
   - ms - manuscript figures / tables
- depr - deprecated (things that have been replaced and will be deleted soon)
- inc - incomplete files
- misc - things we don't know what to do with yet
- plot - plotting functions
- read - tools for reading data into matlab
- tools - project specific data tools that don't go elsewhere
- utils - tools which can also be copied and used on other projects

Some distinctions:
- a tool is something like a data extractor (e.g. get_contrast_levels)
- an analysis is something that requires extensive processing and yields "new" info

## Data import and analysis ##
Our data processing is split into three components:
1) Read the matlab files produced by each recording session. 
2) Process the data into equiv. structures by subsetting it (e.g. valid data).
3) Apply analyses which generate further derived quantities
4) Programatically produce various plots and statistical tests.

Notes / rationale:
- Step (1) derives behavioral quantities necessary for subsetting valid data
- Step (1) produces a data structure `mus` with all sessions and metadata
- Step (2) allows further processing with equivalent code on any subsets.
- Step (3) lets us keep unneccessary analyses from slowing down (1).


- Generally, analyses and plots can then be done by iterating (3) and (4).

## Data organization ##
Step (1) above reads the data into a structure `mus`. This structure has the following format.

```matlab
% Abbreviated field name key by hierarchy depth:
%
% 1) mus = mouse/mice
%
% 2) bhv = behavior
%    PVs = PV cell Ca2+ fluorescence
%    PYs = PY cell Ca2+ fluorescence
%    nfo = metadata for session
%    mta = metadata for mouse
%    xmi = cross modal info such as "signal prob."
%    msc = miscellany not categorizable as above
%
% 3) msk = mask fields (e.g. hit trial mask)
%    nds = linaer index fields (e.g. hit trial numbers) 
%
% Mouse number (mnum) and day number (day) are sequential.
%
% Field list / access examples:

mus{mnum}.bhv{day}.lick_latency
mus{mnum}.bhv{day}...
mus{mnum}.bhv{day}.msk.rew
mus{mnum}.bhv{day}.msk.hits
mus{mnum}.bhv{day}...
mus{mnum}.bhv{day}.nds.rew
mus{mnum}.bhv{day}...

mus{mnum}.PVs{day}.dF
mus{mnum}.PVs{day}.zF
mus{mnum}.PVs{day}.ev
mus{mnum}.PVs{day}...

mus{mnum}.PYs{day}...

mus{mnum}.nfo{day}.trl_cnt
mus{mnum}.nfo{day}.vld_cnt
mus{mnum}.nfo{day}.vld_frc
mus{mnum}.nfo{day}.depths
mus{mnum}.nfo{day}...

mus{mnum}.mta.id
mus{mnum}.mta.files
mus{mnum}.mta...

mus{mnum}.xmi{day}.DP
mus{mnum}.xmi{day}.SP
mus{mnum}.xmi{day}.neurometric
mus{mnum}.xmi{day}...
```

Steps 2 and 3 maintain this format. Sub-formats of PVs and PYs should be identical.

## Example script and function usage ##
