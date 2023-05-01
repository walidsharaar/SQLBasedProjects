/*
Spotify is a digital music streaming service that gives you access to millions of songs, podcasts and videos from artists all over the world.

The Spotify database consists of a single table - tracks, which contains audio statistics of the top 2000 tracks on Spotify. The table contains about 15 columns each describing the track and it's qualities.
*/


--1. List the number of tracks made by each artist. Sort the output by the number of tracks (Descending

select artist, count(*) as "number_of_tracks"
from tracks 
group by artist
order by count(*) desc;

--2. Display the average duration of tracks by genre. Sort the output by the average duration (Descending)

select genre, avg(duration) as "average_duraion"
from tracks 
group by genre
order by avg(duration) desc;

--3. Display the minimum, maximum, and average danceability of tracks made by Queen and The Beatles

select artist, 
       MIN(danceability) as "min_danceability", 
       MAX(danceability) as "max_danceability", 
       AVG(danceability) as "avg_danceability"
from tracks 
where artist in ('Queen', 'The Beatles')
group by artist;

--4. Pop music consists of different genres, for example: Art Pop, Dance Pop, and Candy Pop are all Pop music genres. How many pop music genres are listed in this dataset ?
select count(distinct  genre) "unique_pop_genres"
from tracks
where genre like '%pop%'


--5. Display the number of tracks, highest popularity, and lowest popularity each rock music artist has achieved. Sort the output by the number of tracks (descending)

select artist, 
       count(*) as "number_of_tracks", 
       max(popularity) as "highest_popularity",
       min(popularity) as "lowest_popularity"
from tracks
where genre like '%rock%'
group by artist
order by COUNT(*) desc;


-- 6.Tracks by genre

--a. List the number of tracks by each genre, for tracks released during 2005-2010.

--b. Further restrict your result to display only genres with more than 10 tracks

select genre, count(*) as "number_of_tracks"
from tracks
where release_year in(2005,2010)
group by  genre;

select genre, count(*) as "number_of_tracks"
from tracks
where release_year between  2005 and 2010
group by  genre
having count(*) > 10;

-- 7. List the number of tracks released by Coldplay each year. Sort the output by release_year (ascending)

select artist, release_year, count(*) as "number_of_tracks"
from tracks
where artist = 'Coldplay'
group by artist, release_year;
