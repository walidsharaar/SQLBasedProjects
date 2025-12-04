-- PlayCenter is an imaginary online platform, allowing users to browse and download mobile games of different genres. PlayCenter database consists of a single table: Players - which contains information about the company customers.

-- Write a query to display all of the information inside players
select * from players;

-- Write a query to retrieve the last_name, first_name and city for each player
select last_name, first_name , city 
from 
players;

-- Write a query to retrieve the email_address, country, and street_address for each player
select email_address, country, street_address
from players;

-- Write a query to display the player_id, total_playing_minutes, and installed_games for each player.

select player_id, total_playing_minutes, installed_games
from players;

-- Write a query to display the player_id, age_group, and total_playing_minutes for each player
select player_id, age_group, total_playing_minutes
from players;

-- Write a query to display for each player - the player_id, amount_spent_usd, and a new calculation representing the amount spent in euros, with exchange rate of 0.8.
--Allow us to elaborate, The amount_spent_usd column represents the amount of money spent by each player in USD so if the current exchange rate is 0.8, the calculation would be amount_spent_usd * 0.8.
select player_id,
amount_spent_usd,
amount_spent_usd * 0.8 as amount_spent_euro 
from players

-- Write a query to display the player_id, last_name, first_name, amount_spent_usd, installed_games, and a new calculation representing the average amount spent on each game (amount_spent_usd / installed_games)
select last_name, 
first_name , 
city, 
amount_spent_usd, 
installed_games, 
(amount_spent_usd / installed_games) as average_amount_spent
from 
players;

--Write a query to display for each player - the player_id, email_address, installed_games, uninstalled_games, and a new calculation representing the ratio between installed and uninstalled games (uninstalled_games / installed_games)
select player_id, 
email_address , 
installed_games, 
uninstalled_games, 
(uninstalled_games / installed_games) as game_ratio 
from 
players;

--Write a query to display the: a. player_id b. player's first_name concatenated with his/hers last_name

select player_id,
email_address,
concat(first_name,' ' ,last_name) 
from 
players;


--Write a query to display the: a. player_id b. email_address c. country concatenated with city and street_address d. total playing time in hours (total_playing_minutes / 60)

select player_id,
email_address,
concat(country ,' ',city, ' ',street_address) as address,
(total_playing_minutes/60) as total_time_playing
from players;


-- Write a query to display the following string for each player : ‘full name preferred language is preferred_language’ (full name is the result of concatenating first_name and last_name) for example: 'John Watson preferred language is English'

select 

concat(first_name, ' ', last_name,' preferred language is ', preferred_language ) as preferred

from players;











