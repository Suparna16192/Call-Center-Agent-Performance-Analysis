use new_Schema; 

select * from call_center; 

alter table call_center
modify column AvgTalkDuration time; 

alter table call_center
modify column time time; 

#No of calls

select Date, count(call_ID) as total_calls from call_center
group by Date; 

#Number of answered and unanswered calls 

select `Answered_(Y/N)`, count(call_ID) as total_calls from call_center
group by `Answered_(Y/N)`;

#Overall answer rate 

select round(sum(case when `Answered_(Y/N)` = "Y" then 1 else 0 end) * 100 / count(*),2)  as call_answered_pct from call_center;

#Overall resolution rate 

select round(sum(case when Resolved = "Y" then 1 else 0 end) * 100/count(*),2) as resolution_rate from call_center; 

#resolution rate only among answered calls 

select round(sum(case when Resolved = "Y" then 1 else 0 end)*100/ sum(case when `Answered_(Y/N)` = "Y" then 1 else 0 end),2) as resolved_answers_pct  from call_center; 

#Total calls handled by each agent 

select Agent, count(*) as calls_taken from call_center
group by Agent
order by calls_taken desc; 

#Agent-wise answer rate 

select Agent , count(*) as total_calls, sum(case when `Answered_(Y/N)` = "Y" then 1 else 0 end) as answered_calls,
round(sum(case when `Answered_(Y/N)` = "Y" then 1 else 0 end)*100/count(*),2) as answer_rate from call_center
group by Agent
order by answer_rate desc;

#Agent-wise resolution rate 

select `Agent`, count(*) as total_calls, sum(case when Resolved = "Y" then 1 else 0 end ) as resolved_calls, 
round(sum(case when Resolved = "Y" then 1 else 0 end )*100/count(*),2) as resolved_rate from call_center
group by `Agent`
order by resolved_rate desc; 

#Average speed of answer by agent 

select Agent , round(avg(Speed_of_answer_in_seconds),2) as avg_speed_sec from call_center
where `Answered_(Y/N)` = "Y"
group by Agent
order by avg_speed_sec desc; 

#Average talk duration by agent 

select Agent , round(sec_to_time(avg(time_to_Sec(AvgTalkDuration))),2) as avg_duration from call_center
group by Agent; 

#Average customer satisfaction rating by agent 

select Agent, avg(Satisfaction_rating) as avg_rating from call_center
group by Agent 
order by avg_rating desc; 

#Number of calls by topic 

select topic, count(*) as calls from call_center
group by topic
order by calls; 

#Answer rate by topic 

select topic, count(*) as total_calls , sum(case when `Answered_(Y/N)` = "Y" then 1 else 0 end) as answered_calls, 
round(sum(case when `Answered_(Y/N)` = "Y" then 1 else 0 end)*100/count(*),2) as answered_rate from call_center
group by topic
order by answered_rate;

#Resolution rate by topic 

select topic, count(*) as total_calls , round(sum(case when Resolved = "Y" then 1 else 0 end) * 100/count(*),2) as resolution_rate
from call_center
group by topic
order by resolution_rate;

#Average satisfaction rating by topic 

select topic, avg(Satisfaction_rating) as avg_rating from call_center
group by topic
order by avg_rating desc; 

#Monthly call volume 

select date_format(str_to_date(date, "%d-%m-%Y"), "%Y-%m") as month, count(*) as calls from call_center
group by date_format(str_to_date(date, "%d-%m-%Y"), "%Y-%m"); 

#Calls by hour

select hour(`time`) as hrs , count(*) as calls from call_center
group by hrs
order by hrs; 

#Busiest hour 

select hour(`time`) as hrs , count(*) as calls from call_center
group by hrs
order by calls desc
limit 1;  

#Top-performing agent 

select Agent , count(*) as total_calls, round(sum(case when Resolved = "Y" then 1 else 0 end) * 100/ count(*),2) as resolution_rate,
avg(Satisfaction_rating) as avg_rating from call_center
group by Agent
order by resolution_rate desc, avg_rating  desc; 

#Calls with slow response time 

select count(*) from call_center 
where Speed_of_answer_in_seconds > 60; 

#Create a complete agent performance report 

select Agent, count(*) as total_calls, sum(case when `Answered_(Y/N)` = "Y" then 1 else 0 end) as answerd_calls, 
sum(case when Resolved = "Y" then 1 else 0 end) as resolved_calls, 
round(sum(case when `Answered_(Y/N)` = "Y" then 1 else 0 end)*100/count(*),2) as answered_rate, 
round(sum(case when Resolved = "Y" then 1 else 0 end)*100/count(*),2) as resolved_rate, 
avg(AvgTalkDuration) as AHT , avg(Satisfaction_rating) as rating from call_center
group by Agent
order by resolved_rate desc;