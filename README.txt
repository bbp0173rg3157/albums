# Music Collection Analysis

Digging into my 594 favorite albums to see what patterns emerge. Started 
tracking things like which eras I'm most attached to, how my taste 
evolved, and whether certain genres hit me emotionally vs just being "good 
music."

## What I'm looking at

The data covers album title, artist, genre classifications, release year, 
country, length, seasonal associations, and how sentimentally attached I 
am to each one.

I split my listening into rough life periods:
- Pre-1980: Classic stuff from before my time
- 1980s-1997: The years before I was really aware of music 
- 1997-2010: Childhood era (got into music around '97-'98)
- 2010-2016: High school and college years
- 2017+: Recent discoveries

## Current progress

So far I've written SQL queries to explore:
- Which time periods have the albums I'm most attached to
- Hit rates for different genres - do they connect emotionally or just 
sound good?
- My most productive discovery years
- How my genre preferences shifted over decades
- Album length patterns and weird outliers
- Whether certain seasons correlate with higher attachment

Still planning to do Python analysis and make some visualizations.

## Database setup

```sql
CREATE TABLE albums (
    album_title VARCHAR(255),
    artist VARCHAR(255),
    genre VARCHAR(100),
    genre_umbrella VARCHAR(50),
    release_year INTEGER,
    decade VARCHAR(10),
    country VARCHAR(100),
    length VARCHAR(20),
    season VARCHAR(20),
    sentimental_value VARCHAR(20)
);
```

## Notes

Season info comes from RateYourMusic descriptors. The era splits reflect 
when I actually started paying attention to music and how my taste 
developed through different life stages.
