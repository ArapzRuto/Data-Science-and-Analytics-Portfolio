/*
Global Freight & Logistics Analytics

Project Structure:
1. Data Source & Preparation
2. Data Cleaning & Validation
3. SQL Analysis 
   - Section 1: Daily Shipping & Volume Basics
   - Section 2: Tracking Delays & Delivery Speed
   - Section 3: Breaking Down Data by Port, Hub, or Carrier
   - Section 5: Big-Picture Growth & Cost Tracking
4. Excel Reporting & Dashboard Setup
*/

-- 1. Data Source & Preparation

-- Target Database: Used Already Created Database MyPracticeProjects
-- Schema Name: Created  the Schema Logistics_Shipping_Project

--2. Data Cleaning & Validation

select*from logistics_shipping_dataset lsd ;

-- Check and Correct Data Types

select
	column_name,
	data_type
from
	information_schema.columns
where
	table_schema = 'Logistics_Shipping_Project'
	and table_name = 'logistics_shipping_dataset'
order by
	ordinal_position;

-- Correct Data Types

--Inspect Date column
select lsd.departure_date,lsd.delivery_date 
from logistics_shipping_dataset lsd -- Date column has two formats YYYY-MM-DD, and DD/MM/YYYY

--Convert departure_date text to a real PostgreSQL date

alter table logistics_shipping_dataset
alter column departure_date type date
using to_date(departure_date, 'YYYY-MM-DD');

--delivery_date

select lsd.delivery_date 
from logistics_shipping_dataset lsd 

--Convert departure_date text to a real PostgreSQL date

alter table logistics_shipping_dataset
alter column delivery_date type date
using to_date(delivery_date, 'DD/MM/YYYY');

-- Numerical Columns Datatype Conversion

select shipping_cost, lsd.revenue 
from logistics_shipping_dataset lsd 

alter  table logistics_shipping_dataset 
alter column shipping_cost type numeric
using shipping_cost::numeric;

alter  table logistics_shipping_dataset 
alter column revenue  type numeric
using revenue ::numeric;


--3. SQL Analysis ---

-- section 1: daily shipping & volume basics

-- q1: 3-day rolling sum of dispatched shipments

-- method 1: direct query

select 
    departure_date,
    count(shipment_id) as daily_shipments,
    sum(count(shipment_id)) over (
        order by departure_date
        range between interval '2 days' preceding and current row
    ) as rolling_3day_shipments
from logistics_shipping_dataset
group by departure_date
order by departure_date;

-- method 2: using cte

with daily_shipments as (
    select 
        departure_date,
        count(shipment_id) as total_daily_shipments
    from logistics_shipping_dataset
    group by departure_date
)
select 
    departure_date,
    total_daily_shipments,
    sum(total_daily_shipments) over (
        order by departure_date
        range between interval '2 days' preceding and current row
    ) as rolling_3day_shipments
from daily_shipments
order by departure_date;


-- q2: 7-day rolling freight spend per customer(shipping cost per customer)


select *from logistics_shipping_dataset lsd 

-- method 1: direct query

select 
    customer_id,
    departure_date,
    sum(shipping_cost) as daily_freight_spend_per_customer,
    sum(sum(shipping_cost)) over (
        partition by customer_id
        order by departure_date
        range between interval '6 days' preceding and current row
    ) as rolling_7day_freight_spend_per_customer
from logistics_shipping_dataset
group by customer_id, departure_date
order by customer_id, departure_date;

-- method 2: using cte

with daily_freight_spend_per_customer as (
    select 
        customer_id,
        departure_date,
        sum(shipping_cost) as daily_spend
    from logistics_shipping_dataset
    group by customer_id, departure_date
)
select 
    customer_id,
    departure_date,
    daily_spend,
    sum(daily_spend) over (
        partition by customer_id
        order by departure_date
        range between interval '6 days' preceding and current row
    ) as rolling_7day_freight_spend_per_customer
from daily_freight_spend_per_customer
order by customer_id, departure_date;


-- q3: 7-day rolling window vs. unbounded running total of revenue

-- method 1: direct query

select 
    departure_date,
    revenue,
    sum(revenue) over (
        order by departure_date
        range between interval '6 days' preceding and current row
    ) as rolling_7day_revenue,
    sum(revenue) over (
        order by departure_date
        rows between unbounded preceding and current row
    ) as unbounded_running_revenue
from logistics_shipping_dataset
order by departure_date;

-- method 2: using cte
with raw_data as (
    select departure_date, revenue
    from logistics_shipping_dataset
)
select 
    departure_date,
    revenue,
    sum(revenue) over (
        order by departure_date
        range between interval '6 days' preceding and current row
    ) as rolling_7day_revenue,
    sum(revenue) over (
        order by departure_date
        rows between unbounded preceding and current row
    ) as unbounded_running_revenue
from raw_data
order by departure_date;


-- q4: 7-day rolling shipment counts across dates

-- method 1: direct query

select 
    departure_date,
    count(shipment_id) as daily_shipment_count,
    sum(count(shipment_id)) over (
        order by departure_date
        range between interval '6 days' preceding and current row
    ) as rolling_7day_count
from logistics_shipping_dataset
group by departure_date
order by departure_date;

-- method 2: using cte
with daily_counts as (
    select 
        departure_date,
        count(shipment_id) as daily_shipment_count
    from logistics_shipping_dataset
    group by departure_date
)
select 
    departure_date,
    daily_shipment_count,
    sum(daily_shipment_count) over (
        order by departure_date
        range between interval '6 days' preceding and current row
    ) as rolling_7day_count
from daily_counts
order by departure_date;


-- q5: rolling 3-month billed revenue

-- method 1: direct query

select 
    date_trunc('month', departure_date) as dispatch_month,
    sum(revenue) as total_monthly_revenue,
    sum(sum(revenue)) over (
        order by date_trunc('month', departure_date)
        rows between 2 preceding and current row
    ) as rolling_3month_revenue
from logistics_shipping_dataset
group by date_trunc('month', departure_date)
order by dispatch_month;

-- method 2: using cte

with monthly_revenue as (
    select 
        date_trunc('month', departure_date) as dispatch_month,
        sum(revenue) as total_revenue
    from logistics_shipping_dataset
    group by date_trunc('month', departure_date)
)
select 
    dispatch_month,
    total_revenue,
    sum(total_revenue) over (
        order by dispatch_month
        rows between 2 preceding and current row
    ) as rolling_3month_revenue
from monthly_revenue
order by dispatch_month;


-- q6: 7-day rolling revenue by service tier (seat_class)

-- method 1: direct query
select 
    seat_class,
    departure_date,
    sum(revenue) as daily_revenue,
    sum(sum(revenue)) over (
        partition by seat_class
        order by departure_date
        range between interval '6 days' preceding and current row
    ) as rolling_7day_tier_revenue
from logistics_shipping_dataset
group by seat_class, departure_date
order by seat_class, departure_date;

-- method 2: using cte
with daily_tier_revenue as (
    select 
        seat_class,
        departure_date,
        sum(revenue) as daily_revenue
    from logistics_shipping_dataset
    group by seat_class, departure_date
)
select 
    seat_class,
    departure_date,
    daily_revenue,
    sum(daily_revenue) over (
        partition by seat_class
        order by departure_date
        range between interval '6 days' preceding and current row
    ) as rolling_7day_tier_revenue
from daily_tier_revenue
order by seat_class, departure_date;


-- q7: 30-day rolling net profit

-- method 1: direct query

select 
    departure_date,
    sum(revenue - shipping_cost) as daily_net_profit,
    sum(sum(revenue - shipping_cost)) over (
        order by departure_date
        range between interval '29 days' preceding and current row
    ) as rolling_30day_net_profit
from logistics_shipping_dataset
group by departure_date
order by departure_date;

-- method 2: using cte
with daily_profit as (
    select 
        departure_date,
        sum(revenue - shipping_cost) as net_profit
    from logistics_shipping_dataset
    group by departure_date
)
select 
    departure_date,
    net_profit as daily_net_profit,
    sum(net_profit) over (
        order by departure_date
        range between interval '29 days' preceding and current row
    ) as rolling_30day_net_profit
from daily_profit
order by departure_date;


-- q8: 7-day rolling shipment count per origin hub

-- method 1: direct query

select 
    origin,
    departure_date,
    count(shipment_id) as daily_shipments,
    sum(count(shipment_id)) over (
        partition by origin
        order by departure_date
        range between interval '6 days' preceding and current row
    ) as rolling_7day_origin_shipments
from logistics_shipping_dataset
group by origin, departure_date
order by origin, departure_date;

-- method 2: using cte

with daily_origin_volume as (
    select 
        origin,
        departure_date,
        count(shipment_id) as daily_shipments
    from logistics_shipping_dataset
    group by origin, departure_date
)
select 
    origin,
    departure_date,
    daily_shipments,
    sum(daily_shipments) over (
        partition by origin
        order by departure_date
        range between interval '6 days' preceding and current row
    ) as rolling_7day_origin_shipments
from daily_origin_volume
order by origin, departure_date;


-- q9: rolling 12-month gross revenue

-- method 1: direct query

select 
    date_trunc('month', departure_date) as dispatch_month,
    sum(revenue) as gross_revenue,
    sum(sum(revenue)) over (
        order by date_trunc('month', departure_date)
        rows between 11 preceding and current row
    ) as rolling_12month_gross_revenue
from logistics_shipping_dataset
group by date_trunc('month', departure_date)
order by dispatch_month;

-- method 2: using cte
with monthly_revenue as (
    select 
        date_trunc('month', departure_date) as dispatch_month,
        sum(revenue) as gross_revenue
    from logistics_shipping_dataset
    group by date_trunc('month', departure_date)
)
select 
    dispatch_month,
    gross_revenue,
    sum(gross_revenue) over (
        order by dispatch_month
        rows between 11 preceding and current row
    ) as rolling_12month_gross_revenue
from monthly_revenue
order by dispatch_month;



-- section 2: tracking delays & delivery speed

-- q1: highest 7-day delayed shipment period

-- method 1: direct query
select departure_date, rolling_7day_delay_count
from (
    select 
        departure_date,
        sum(count(case when shipping_status = 'Delayed' then 1 end)) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as rolling_7day_delay_count
    from logistics_shipping_dataset
    group by departure_date
) sub
order by rolling_7day_delay_count desc
limit 1;

-- method 2: using cte
with daily_delays as (
    select 
        departure_date,
        count(case when shipping_status = 'Delayed' then 1 end) as daily_delayed_count
    from logistics_shipping_dataset
    group by departure_date
),
rolling_delays as (
    select 
        departure_date,
        sum(daily_delayed_count) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as rolling_7day_delay_count
    from daily_delays
)
select departure_date, rolling_7day_delay_count
from rolling_delays
order by rolling_7day_delay_count desc
limit 1;



-- q2: 7-day rolling delayed shipments by origin port

-- method 1: direct query
select 
    origin,
    departure_date,
    count(case when shipping_status = 'Delayed' then 1 end) as daily_delays,
    sum(count(case when shipping_status = 'Delayed' then 1 end)) over (
        partition by origin
        order by departure_date
        range between interval '6 days' preceding and current row
    ) as rolling_7day_origin_delays
from logistics_shipping_dataset
group by origin, departure_date
order by origin, departure_date;

-- method 2: using cte
with daily_origin_delays as (
    select 
        origin,
        departure_date,
        count(case when shipping_status = 'Delayed' then 1 end) as daily_delays
    from logistics_shipping_dataset
    group by origin, departure_date
)
select 
    origin,
    departure_date,
    daily_delays,
    sum(daily_delays) over (
        partition by origin
        order by departure_date
        range between interval '6 days' preceding and current row
    ) as rolling_7day_origin_delays
from daily_origin_delays
order by origin, departure_date;


-- q3: 7-day rolling average transit lead time

-- method 1: direct query
select 
    departure_date,
    round(avg(delivery_date - departure_date), 2) as daily_avg_lead_time_days,
    round(avg(avg(delivery_date - departure_date)) over (
        order by departure_date
        range between interval '6 days' preceding and current row
    ), 2) as rolling_7day_avg_lead_time
from logistics_shipping_dataset
where shipping_status = 'Delivered' and delivery_date is not null
group by departure_date
order by departure_date;

-- method 2: using cte
with daily_lead_time as (
    select 
        departure_date,
        avg(delivery_date - departure_date) as avg_daily_lead_time
    from logistics_shipping_dataset
    where shipping_status = 'Delivered'
      and delivery_date is not null
    group by departure_date
)
select 
    departure_date,
    round(avg_daily_lead_time, 2) as daily_avg_lead_time_days,
    round(avg(avg_daily_lead_time) over (
        order by departure_date
        range between interval '6 days' preceding and current row
    ), 2) as rolling_7day_avg_lead_time
from daily_lead_time
order by departure_date;


-- q4: current vs. previous 7-day rolling average lead time

-- method 1: direct query
select 
    departure_date,
    round(current_7day_avg, 2) as current_7day_avg,
    round(lag(current_7day_avg) over (order by departure_date), 2) as prev_day_7day_avg,
    round(current_7day_avg - lag(current_7day_avg) over (order by departure_date), 2) as lead_time_change
from (
    select 
        departure_date,
        avg(avg(delivery_date - departure_date)) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as current_7day_avg
    from logistics_shipping_dataset
    where shipping_status = 'Delivered'
    group by departure_date
) sub
order by departure_date;

-- method 2: using cte
with daily_lead_time as (
    select 
        departure_date,
        avg(delivery_date - departure_date) as daily_avg
    from logistics_shipping_dataset
    where shipping_status = 'Delivered'
    group by departure_date
),
rolling_lead_time as (
    select 
        departure_date,
        avg(daily_avg) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as current_7day_avg_lead_time
    from daily_lead_time
)
select 
    departure_date,
    round(current_7day_avg_lead_time, 2) as current_7day_avg,
    round(lag(current_7day_avg_lead_time) over (order by departure_date), 2) as prev_day_7day_avg,
    round(current_7day_avg_lead_time - lag(current_7day_avg_lead_time) over (order by departure_date), 2) as lead_time_change
from rolling_lead_time
order by departure_date;


-- q5: 7-day rolling delay rate by service tier (seat_class)

-- method 1: direct query
select 
    seat_class,
    departure_date,
    rolling_7day_delays,
    rolling_7day_total,
    round((rolling_7day_delays::numeric / nullif(rolling_7day_total, 0)) * 100, 2) as rolling_7day_delay_rate_pct
from (
    select 
        seat_class,
        departure_date,
        sum(count(case when shipping_status = 'Delayed' then 1 end)) over (
            partition by seat_class
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as rolling_7day_delays,
        sum(count(shipment_id)) over (
            partition by seat_class
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as rolling_7day_total
    from logistics_shipping_dataset
    group by seat_class, departure_date
) sub
order by seat_class, departure_date;

-- method 2: using cte
with daily_tier_status as (
    select 
        seat_class,
        departure_date,
        count(case when shipping_status = 'Delayed' then 1 end) as delayed_cnt,
        count(shipment_id) as total_cnt
    from logistics_shipping_dataset
    group by seat_class, departure_date
),
rolling_tier_counts as (
    select 
        seat_class,
        departure_date,
        sum(delayed_cnt) over (
            partition by seat_class
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as rolling_7day_delays,
        sum(total_cnt) over (
            partition by seat_class
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as rolling_7day_total
    from daily_tier_status
)
select 
    seat_class,
    departure_date,
    rolling_7day_delays,
    rolling_7day_total,
    round((rolling_7day_delays::numeric / nullif(rolling_7day_total, 0)) * 100, 2) as rolling_7day_delay_rate_pct
from rolling_tier_counts
order by seat_class, departure_date;


-- q6: conditional accumulator reset on date gaps (>1 day)

-- method 1: direct query
select 
    departure_date,
    daily_cnt,
    sum(daily_cnt) over (
        partition by group_id
        order by departure_date
    ) as running_shipments_reset_on_gap
from (
    select 
        departure_date,
        daily_cnt,
        sum(case when departure_date - prev_date > 1 then 1 else 0 end) over (order by departure_date) as group_id
    from (
        select 
            departure_date,
            count(shipment_id) as daily_cnt,
            lag(departure_date) over (order by departure_date) as prev_date
        from logistics_shipping_dataset
        group by departure_date
    ) sub1
) sub2
order by departure_date;

-- method 2: using cte
with date_lags as (
    select 
        departure_date,
        count(shipment_id) as daily_cnt,
        lag(departure_date) over (order by departure_date) as prev_date
    from logistics_shipping_dataset
    group by departure_date
),
gap_flags as (
    select 
        departure_date,
        daily_cnt,
        case when departure_date - prev_date > 1 then 1 else 0 end as is_new_group
    from date_lags
),
group_identifiers as (
    select 
        departure_date,
        daily_cnt,
        sum(is_new_group) over (order by departure_date) as group_id
    from gap_flags
)
select 
    departure_date,
    daily_cnt,
    sum(daily_cnt) over (
        partition by group_id
        order by departure_date
    ) as running_shipments_reset_on_gap
from group_identifiers
order by departure_date;


-- q7: month-to-date (mtd) rolling gross revenue

-- method 1: direct query
select 
    departure_date,
    sum(revenue) as daily_rev,
    sum(sum(revenue)) over (
        partition by date_trunc('month', departure_date)
        order by departure_date
        rows between unbounded preceding and current row
    ) as mtd_rolling_revenue
from logistics_shipping_dataset
group by departure_date
order by departure_date;

-- method 2: using cte
with daily_revenue as (
    select 
        departure_date,
        sum(revenue) as daily_rev
    from logistics_shipping_dataset
    group by departure_date
)
select 
    departure_date,
    daily_rev,
    sum(daily_rev) over (
        partition by date_trunc('month', departure_date)
        order by departure_date
        rows between unbounded preceding and current row
    ) as mtd_rolling_revenue
from daily_revenue
order by departure_date;


-- q8: 3-day rolling operating expense (shipping_cost) by priority tier

-- method 1: direct query
select 
    seat_class,
    departure_date,
    sum(shipping_cost) as total_daily_cost,
    round(avg(sum(shipping_cost)) over (
        partition by seat_class
        order by departure_date
        range between interval '2 days' preceding and current row
    ), 2) as rolling_3day_avg_cost
from logistics_shipping_dataset
group by seat_class, departure_date
order by seat_class, departure_date;

-- method 2: using cte
with daily_tier_cost as (
    select 
        seat_class,
        departure_date,
        sum(shipping_cost) as total_daily_cost
    from logistics_shipping_dataset
    group by seat_class, departure_date
)
select 
    seat_class,
    departure_date,
    total_daily_cost,
    round(avg(total_daily_cost) over (
        partition by seat_class
        order by departure_date
        range between interval '2 days' preceding and current row
    ), 2) as rolling_3day_avg_cost
from daily_tier_cost
order by seat_class, departure_date;


-- q9: 7-day rolling freight spend per customer account

-- method 1: direct query

select 
    customer_id,
    departure_date,
    sum(shipping_cost) as daily_customer_cost,
    round(avg(sum(shipping_cost)) over (
        partition by customer_id
        order by departure_date
        range between interval '6 days' preceding and current row
    ), 2) as rolling_7day_avg_spend
from logistics_shipping_dataset
group by customer_id, departure_date
order by customer_id, departure_date;

-- method 2: using cte
with daily_customer_cost as (
    select 
        customer_id,
        departure_date,
        sum(shipping_cost) as daily_customer_cost
    from logistics_shipping_dataset
    group by customer_id, departure_date
)
select 
    customer_id,
    departure_date,
    daily_customer_cost,
    round(avg(daily_customer_cost) over (
        partition by customer_id
        order by departure_date
        range between interval '6 days' preceding and current row
    ), 2) as rolling_7day_avg_spend
from daily_customer_cost
order by customer_id, departure_date;



-- section 3: breaking down data by port, hub, or carrier

-- q1: 14-day rolling total shipments by origin port

-- method 1: direct query

select 
    origin,
    departure_date,
    count(shipment_id) as daily_shipments,
    sum(count(shipment_id)) over (
        partition by origin
        order by departure_date
        range between interval '13 days' preceding and current row
    ) as rolling_14day_origin_shipments
from logistics_shipping_dataset
group by origin, departure_date
order by origin, departure_date;

-- method 2: using cte
with daily_origin_volume as (
    select 
        origin,
        departure_date,
        count(shipment_id) as daily_shipments
    from logistics_shipping_dataset
    group by origin, departure_date
)
select 
    origin,
    departure_date,
    daily_shipments,
    sum(daily_shipments) over (
        partition by origin
        order by departure_date
        range between interval '13 days' preceding and current row
    ) as rolling_14day_origin_shipments
from daily_origin_volume
order by origin, departure_date;


-- q2: 30-day rolling average shipping cost by destination port

-- method 1: direct query
select 
    destination,
    departure_date,
    round(avg(shipping_cost), 2) as avg_daily_cost,
    round(avg(avg(shipping_cost)) over (
        partition by destination
        order by departure_date
        range between interval '29 days' preceding and current row
    ), 2) as rolling_30day_avg_shipping_cost
from logistics_shipping_dataset
group by destination, departure_date
order by destination, departure_date;

-- method 2: using cte
with daily_dest_cost as (
    select 
        destination,
        departure_date,
        avg(shipping_cost) as avg_daily_cost
    from logistics_shipping_dataset
    group by destination, departure_date
)
select 
    destination,
    departure_date,
    round(avg_daily_cost, 2) as avg_daily_cost,
    round(avg(avg_daily_cost) over (
        partition by destination
        order by departure_date
        range between interval '29 days' preceding and current row
    ), 2) as rolling_30day_avg_shipping_cost
from daily_dest_cost
order by destination, departure_date;


-- q3: 3-month rolling average net profit by service tier (seat_class)

-- method 1: direct query
select 
    seat_class,
    date_trunc('month', departure_date) as dispatch_month,
    sum(revenue - shipping_cost) as monthly_profit,
    round(avg(sum(revenue - shipping_cost)) over (
        partition by seat_class
        order by date_trunc('month', departure_date)
        rows between 2 preceding and current row
    ), 2) as rolling_3month_avg_profit
from logistics_shipping_dataset
group by seat_class, date_trunc('month', departure_date)
order by seat_class, dispatch_month;

-- method 2: using cte
with monthly_tier_profit as (
    select 
        seat_class,
        date_trunc('month', departure_date) as dispatch_month,
        sum(revenue - shipping_cost) as monthly_profit
    from logistics_shipping_dataset
    group by seat_class, date_trunc('month', departure_date)
)
select 
    seat_class,
    dispatch_month,
    monthly_profit,
    round(avg(monthly_profit) over (
        partition by seat_class
        order by dispatch_month
        rows between 2 preceding and current row
    ), 2) as rolling_3month_avg_profit
from monthly_tier_profit
order by seat_class, dispatch_month;


-- q4: 6-month rolling gross revenue by trade lane (origin -> destination)

-- method 1: direct query
select 
    origin || ' -> ' || destination as trade_corridor,
    date_trunc('month', departure_date) as dispatch_month,
    sum(revenue) as monthly_revenue,
    sum(sum(revenue)) over (
        partition by origin, destination
        order by date_trunc('month', departure_date)
        rows between 5 preceding and current row
    ) as rolling_6month_revenue
from logistics_shipping_dataset
group by origin, destination, date_trunc('month', departure_date)
order by trade_corridor, dispatch_month;

-- method 2: using cte
with monthly_corridor_revenue as (
    select 
        origin,
        destination,
        date_trunc('month', departure_date) as dispatch_month,
        sum(revenue) as monthly_revenue
    from logistics_shipping_dataset
    group by origin, destination, date_trunc('month', departure_date)
)
select 
    origin || ' -> ' || destination as trade_corridor,
    dispatch_month,
    monthly_revenue,
    sum(monthly_revenue) over (
        partition by origin, destination
        order by dispatch_month
        rows between 5 preceding and current row
    ) as rolling_6month_revenue
from monthly_corridor_revenue
order by trade_corridor, dispatch_month;


-- q5: 12-month rolling average transit lead time per trade corridor

-- method 1: direct query
select 
    origin || ' -> ' || destination as trade_corridor,
    date_trunc('month', departure_date) as dispatch_month,
    round(avg(delivery_date - departure_date), 2) as avg_monthly_lead_time_days,
    round(avg(avg(delivery_date - departure_date)) over (
        partition by origin, destination
        order by date_trunc('month', departure_date)
        rows between 11 preceding and current row
    ), 2) as rolling_12month_avg_lead_time
from logistics_shipping_dataset
where shipping_status = 'Delivered'
group by origin, destination, date_trunc('month', departure_date)
order by trade_corridor, dispatch_month;

-- method 2: using cte
with monthly_corridor_lead_time as (
    select 
        origin,
        destination,
        date_trunc('month', departure_date) as dispatch_month,
        avg(delivery_date - departure_date) as avg_monthly_lead_time
    from logistics_shipping_dataset
    where shipping_status = 'Delivered'
    group by origin, destination, date_trunc('month', departure_date)
)
select 
    origin || ' -> ' || destination as trade_corridor,
    dispatch_month,
    round(avg_monthly_lead_time, 2) as avg_monthly_lead_time_days,
    round(avg(avg_monthly_lead_time) over (
        partition by origin, destination
        order by dispatch_month
        rows between 11 preceding and current row
    ), 2) as rolling_12month_avg_lead_time
from monthly_corridor_lead_time
order by trade_corridor, dispatch_month;


-- q6: unbounded running total of total shipments over time

-- method 1: direct query
select 
    departure_date,
    count(shipment_id) as daily_shipments,
    sum(count(shipment_id)) over (
        order by departure_date
        rows between unbounded preceding and current row
    ) as unbounded_running_total_shipments
from logistics_shipping_dataset
group by departure_date
order by departure_date;

-- method 2: using cte
with daily_counts as (
    select 
        departure_date,
        count(shipment_id) as daily_shipments
    from logistics_shipping_dataset
    group by departure_date
)
select 
    departure_date,
    daily_shipments,
    sum(daily_shipments) over (
        order by departure_date
        rows between unbounded preceding and current row
    ) as unbounded_running_total_shipments
from daily_counts
order by departure_date;


-- q7: unbounded running total of freight spend per client account (customer_id)

-- method 1: direct query
select 
    customer_id,
    departure_date,
    sum(shipping_cost) as daily_spend,
    sum(sum(shipping_cost)) over (
        partition by customer_id
        order by departure_date
        rows between unbounded preceding and current row
    ) as cumulative_customer_spend
from logistics_shipping_dataset
group by customer_id, departure_date
order by customer_id, departure_date;

-- method 2: using cte
with daily_customer_spend as (
    select 
        customer_id,
        departure_date,
        sum(shipping_cost) as daily_spend
    from logistics_shipping_dataset
    group by customer_id, departure_date
)
select 
    customer_id,
    departure_date,
    daily_spend,
    sum(daily_spend) over (
        partition by customer_id
        order by departure_date
        rows between unbounded preceding and current row
    ) as cumulative_customer_spend
from daily_customer_spend
order by customer_id, departure_date;


-- q8: cumulative revenue partitioned by service tier (seat_class)

-- method 1: direct query
select 
    seat_class,
    departure_date,
    sum(revenue) as daily_revenue,
    sum(sum(revenue)) over (
        partition by seat_class
        order by departure_date
        rows between unbounded preceding and current row
    ) as cumulative_tier_revenue
from logistics_shipping_dataset
group by seat_class, departure_date
order by seat_class, departure_date;

-- method 2: using cte
with daily_tier_rev as (
    select 
        seat_class,
        departure_date,
        sum(revenue) as daily_revenue
    from logistics_shipping_dataset
    group by seat_class, departure_date
)
select 
    seat_class,
    departure_date,
    daily_revenue,
    sum(daily_revenue) over (
        partition by seat_class
        order by departure_date
        rows between unbounded preceding and current row
    ) as cumulative_tier_revenue
from daily_tier_rev
order by seat_class, departure_date;


-- q9: daily shipment count vs. 7-day rolling average shipment volume

-- method 1: direct query
select 
    departure_date,
    count(shipment_id) as daily_shipments,
    round(avg(count(shipment_id)) over (
        order by departure_date
        range between interval '6 days' preceding and current row
    ), 2) as rolling_7day_avg_volume,
    round(count(shipment_id) - avg(count(shipment_id)) over (
        order by departure_date
        range between interval '6 days' preceding and current row
    ), 2) as variance_from_7day_avg
from logistics_shipping_dataset
group by departure_date
order by departure_date;

-- method 2: using cte
with daily_volume as (
    select 
        departure_date,
        count(shipment_id) as daily_shipments
    from logistics_shipping_dataset
    group by departure_date
)
select 
    departure_date,
    daily_shipments,
    round(avg(daily_shipments) over (
        order by departure_date
        range between interval '6 days' preceding and current row
    ), 2) as rolling_7day_avg_volume,
    round(daily_shipments - avg(daily_shipments) over (
        order by departure_date
        range between interval '6 days' preceding and current row
    ), 2) as variance_from_7day_avg
from daily_volume
order by departure_date;


-- q10: dates where 7-day rolling net profit was higher than prior day's 7-day profit

-- method 1: direct query
select departure_date, current_7day_profit, prev_7day_profit, profit_growth
from (
    select 
        departure_date,
        current_7day_profit,
        lag(current_7day_profit) over (order by departure_date) as prev_7day_profit,
        (current_7day_profit - lag(current_7day_profit) over (order by departure_date)) as profit_growth
    from (
        select 
            departure_date,
            sum(sum(revenue - shipping_cost)) over (
                order by departure_date
                range between interval '6 days' preceding and current row
            ) as current_7day_profit
        from logistics_shipping_dataset
        group by departure_date
    ) sub1
) sub2
where current_7day_profit > prev_7day_profit
order by departure_date;

-- method 2: using cte
with daily_profit as (
    select 
        departure_date,
        sum(revenue - shipping_cost) as net_profit
    from logistics_shipping_dataset
    group by departure_date
),
rolling_profit as (
    select 
        departure_date,
        sum(net_profit) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as current_7day_profit
    from daily_profit
),
profit_comparison as (
    select 
        departure_date,
        current_7day_profit,
        lag(current_7day_profit) over (order by departure_date) as prev_7day_profit
    from rolling_profit
)
select 
    departure_date,
    current_7day_profit,
    prev_7day_profit,
    (current_7day_profit - prev_7day_profit) as profit_growth
from profit_comparison
where current_7day_profit > prev_7day_profit
order by departure_date;



-- section 4: spotting busy seasons & busy routes

-- q1: dates where 7-day rolling shipment volume decreased

-- method 1: using cte

with daily_vol as (
    select 
        departure_date,
        count(shipment_id) as daily_cnt
    from logistics_shipping_dataset
    group by departure_date
),
rolling_vol as (
    select 
        departure_date,
        sum(daily_cnt) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as vol_7d
    from daily_vol
),
volume_trends as (
    select 
        departure_date,
        vol_7d,
        lag(vol_7d) over (order by departure_date) as prev_vol_7d
    from rolling_vol
)
select 
    departure_date,
    vol_7d as current_7day_volume,
    prev_vol_7d as previous_7day_volume,
    (prev_vol_7d - vol_7d) as volume_drop
from volume_trends
where vol_7d < prev_vol_7d
order by departure_date;


-- q2: corridors where 7-day rolling revenue increased for 3 consecutive days

-- method 1: direct query
select distinct trade_corridor, departure_date, rev_7d as current_revenue
from (
    select 
        trade_corridor,
        departure_date,
        rev_7d,
        lag(rev_7d, 1) over (partition by trade_corridor order by departure_date) as d1,
        lag(rev_7d, 2) over (partition by trade_corridor order by departure_date) as d2,
        lag(rev_7d, 3) over (partition by trade_corridor order by departure_date) as d3
    from (
        select 
            origin || ' -> ' || destination as trade_corridor,
            departure_date,
            sum(sum(revenue)) over (
                partition by origin, destination
                order by departure_date
                range between interval '6 days' preceding and current row
            ) as rev_7d
        from logistics_shipping_dataset
        group by origin, destination, departure_date
    ) sub1
) sub2
where rev_7d > d1 and d1 > d2 and d2 > d3
order by trade_corridor, departure_date;

-- method 2: using cte
with daily_corridor_rev as (
    select 
        origin,
        destination,
        departure_date,
        sum(revenue) as daily_rev
    from logistics_shipping_dataset
    group by origin, destination, departure_date
),
rolling_corridor_rev as (
    select 
        origin || ' -> ' || destination as trade_corridor,
        departure_date,
        sum(daily_rev) over (
            partition by origin, destination
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as rev_7d
    from daily_corridor_rev
),
consecutive_growth as (
    select 
        trade_corridor,
        departure_date,
        rev_7d,
        lag(rev_7d, 1) over (partition by trade_corridor order by departure_date) as d1,
        lag(rev_7d, 2) over (partition by trade_corridor order by departure_date) as d2,
        lag(rev_7d, 3) over (partition by trade_corridor order by departure_date) as d3
    from rolling_corridor_rev
)
select distinct 
    trade_corridor,
    departure_date,
    rev_7d as current_revenue
from consecutive_growth
where rev_7d > d1 
  and d1 > d2 
  and d2 > d3
order by trade_corridor, departure_date;


-- q3: 7-day rolling delivered shipments drop for 3 consecutive days

-- method 1: direct query
select departure_date, deliv_7d as current_rolling_delivered
from (
    select 
        departure_date,
        deliv_7d,
        lag(deliv_7d, 1) over (order by departure_date) as d1,
        lag(deliv_7d, 2) over (order by departure_date) as d2,
        lag(deliv_7d, 3) over (order by departure_date) as d3
    from (
        select 
            departure_date,
            sum(count(shipment_id)) over (
                order by departure_date
                range between interval '6 days' preceding and current row
            ) as deliv_7d
        from logistics_shipping_dataset
        where shipping_status = 'Delivered'
        group by departure_date
    ) sub1
) sub2
where deliv_7d < d1 and d1 < d2 and d2 < d3
order by departure_date;

-- method 2: using cte
with daily_delivered as (
    select 
        departure_date,
        count(shipment_id) as delivered_cnt
    from logistics_shipping_dataset
    where shipping_status = 'Delivered'
    group by departure_date
),
rolling_delivered as (
    select 
        departure_date,
        sum(delivered_cnt) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as deliv_7d
    from daily_delivered
),
trend_analysis as (
    select 
        departure_date,
        deliv_7d,
        lag(deliv_7d, 1) over (order by departure_date) as d1,
        lag(deliv_7d, 2) over (order by departure_date) as d2,
        lag(deliv_7d, 3) over (order by departure_date) as d3
    from rolling_delivered
)
select 
    departure_date,
    deliv_7d as current_rolling_delivered
from trend_analysis
where deliv_7d < d1 
  and d1 < d2 
  and d2 < d3
order by departure_date;


-- q4: peak 7-day rolling revenue window for each origin hub

-- method 1: direct query
select origin, departure_date as peak_window_end_date, rev_7d as max_7day_revenue
from (
    select 
        origin,
        departure_date,
        rev_7d,
        row_number() over (partition by origin order by rev_7d desc, departure_date asc) as rnk
    from (
        select 
            origin,
            departure_date,
            sum(sum(revenue)) over (
                partition by origin
                order by departure_date
                range between interval '6 days' preceding and current row
            ) as rev_7d
        from logistics_shipping_dataset
        group by origin, departure_date
    ) sub1
) sub2
where rnk = 1
order by origin;

-- method 2: using cte
with daily_origin_rev as (
    select 
        origin,
        departure_date,
        sum(revenue) as daily_rev
    from logistics_shipping_dataset
    group by origin, departure_date
),
rolling_origin_rev as (
    select 
        origin,
        departure_date,
        sum(daily_rev) over (
            partition by origin
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as rev_7d
    from daily_origin_rev
),
ranked_windows as (
    select 
        origin,
        departure_date,
        rev_7d,
        row_number() over (
            partition by origin 
            order by rev_7d desc, departure_date asc
        ) as rnk
    from rolling_origin_rev
)
select 
    origin,
    departure_date as peak_window_end_date,
    rev_7d as max_7day_revenue
from ranked_windows
where rnk = 1
order by origin;


-- q5: peak 30-day rolling shipment volume period for each destination port

-- method 1: direct query
select destination, departure_date as peak_30day_window_end_date, vol_30d as max_30day_volume
from (
    select 
        destination,
        departure_date,
        vol_30d,
        row_number() over (partition by destination order by vol_30d desc, departure_date asc) as rnk
    from (
        select 
            destination,
            departure_date,
            sum(count(shipment_id)) over (
                partition by destination
                order by departure_date
                range between interval '29 days' preceding and current row
            ) as vol_30d
        from logistics_shipping_dataset
        group by destination, departure_date
    ) sub1
) sub2
where rnk = 1
order by destination;

-- method 2: using cte
with daily_dest_vol as (
    select 
        destination,
        departure_date,
        count(shipment_id) as daily_cnt
    from logistics_shipping_dataset
    group by destination, departure_date
),
rolling_dest_vol as (
    select 
        destination,
        departure_date,
        sum(daily_cnt) over (
            partition by destination
            order by departure_date
            range between interval '29 days' preceding and current row
        ) as vol_30d
    from daily_dest_vol
),
ranked_destinations as (
    select 
        destination,
        departure_date,
        vol_30d,
        row_number() over (
            partition by destination 
            order by vol_30d desc, departure_date asc
        ) as rnk
    from rolling_dest_vol
)
select 
    destination,
    departure_date as peak_30day_window_end_date,
    vol_30d as max_30day_volume
from ranked_destinations
where rnk = 1
order by destination;


-- q6: rank each day by 7-day rolling gross revenue using dense_rank()

-- method 1: direct query
select 
    departure_date,
    rolling_7day_gross_revenue,
    dense_rank() over (order by rolling_7day_gross_revenue desc) as revenue_rank
from (
    select 
        departure_date,
        sum(sum(revenue)) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as rolling_7day_gross_revenue
    from logistics_shipping_dataset
    group by departure_date
) sub
order by revenue_rank asc, departure_date asc;

-- method 2: using cte
with daily_rev as (
    select 
        departure_date,
        sum(revenue) as daily_gross_revenue
    from logistics_shipping_dataset
    group by departure_date
),
rolling_rev as (
    select 
        departure_date,
        sum(daily_gross_revenue) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as rolling_7day_gross_revenue
    from daily_rev
)
select 
    departure_date,
    rolling_7day_gross_revenue,
    dense_rank() over (
        order by rolling_7day_gross_revenue desc
    ) as revenue_rank
from rolling_rev
order by revenue_rank asc, departure_date asc;


-- q7: top 5 distinct 7-day windows recording highest total net profit

-- method 1: direct query
select distinct
    departure_date as window_end_date,
    rolling_7day_net_profit
from (
    select 
        departure_date,
        sum(sum(revenue - shipping_cost)) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as rolling_7day_net_profit
    from logistics_shipping_dataset
    group by departure_date
) sub
order by rolling_7day_net_profit desc
limit 5;

-- method 2: using cte
with daily_profit as (
    select 
        departure_date,
        sum(revenue - shipping_cost) as daily_net_profit
    from logistics_shipping_dataset
    group by departure_date
),
rolling_profit as (
    select 
        departure_date,
        sum(daily_net_profit) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as rolling_7day_net_profit
    from daily_profit
)
select distinct
    departure_date as window_end_date,
    rolling_7day_net_profit
from rolling_profit
order by rolling_7day_net_profit desc
limit 5;


-- q8: top 3 trade corridors based on peak 7-day rolling cargo volume

-- method 1: direct query
select 
    trade_corridor,
    max(vol_7d) as peak_7day_cargo_volume
from (
    select 
        origin || ' -> ' || destination as trade_corridor,
        sum(count(shipment_id)) over (
            partition by origin, destination
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as vol_7d
    from logistics_shipping_dataset
    group by origin, destination, departure_date
) sub
group by trade_corridor
order by peak_7day_cargo_volume desc
limit 3;

-- method 2: using cte
with daily_corridor_vol as (
    select 
        origin,
        destination,
        departure_date,
        count(shipment_id) as daily_cnt
    from logistics_shipping_dataset
    group by origin, destination, departure_date
),
rolling_corridor_vol as (
    select 
        origin || ' -> ' || destination as trade_corridor,
        sum(daily_cnt) over (
            partition by origin, destination
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as vol_7d
    from daily_corridor_vol
),
peak_corridor_vols as (
    select 
        trade_corridor,
        max(vol_7d) as peak_7day_cargo_volume
    from rolling_corridor_vol
    group by trade_corridor
)
select 
    trade_corridor,
    peak_7day_cargo_volume
from peak_corridor_vols
order by peak_7day_cargo_volume desc
limit 3;


-- q9: top 3 destination ports based on highest 30-day rolling revenue

-- method 1: direct query
select 
    destination,
    max(rev_30d) as max_30day_revenue
from (
    select 
        destination,
        sum(sum(revenue)) over (
            partition by destination
            order by departure_date
            range between interval '29 days' preceding and current row
        ) as rev_30d
    from logistics_shipping_dataset
    group by destination, departure_date
) sub
group by destination
order by max_30day_revenue desc
limit 3;

-- method 2: using cte
with daily_dest_rev as (
    select 
        destination,
        departure_date,
        sum(revenue) as daily_rev
    from logistics_shipping_dataset
    group by destination, departure_date
),
rolling_dest_rev as (
    select 
        destination,
        sum(daily_rev) over (
            partition by destination
            order by departure_date
            range between interval '29 days' preceding and current row
        ) as rev_30d
    from daily_dest_rev
),
peak_dest_rev as (
    select 
        destination,
        max(rev_30d) as max_30day_revenue
    from rolling_dest_rev
    group by destination
)
select 
    destination,
    max_30day_revenue
from peak_dest_rev
order by max_30day_revenue desc
limit 3;


-- q10: top customer account in each 7-day rolling window

-- method 1: direct query
select window_end_date, top_customer, total_7day_spend
from (
    select 
        departure_date as window_end_date,
        customer_id as top_customer,
        spend_7d as total_7day_spend,
        row_number() over (partition by departure_date order by spend_7d desc) as rnk
    from (
        select 
            customer_id,
            departure_date,
            sum(sum(shipping_cost)) over (
                partition by customer_id
                order by departure_date
                range between interval '6 days' preceding and current row
            ) as spend_7d
        from logistics_shipping_dataset
        group by customer_id, departure_date
    ) sub1
) sub2
where rnk = 1
order by window_end_date;

-- method 2: using cte
with daily_customer_spend as (
    select 
        customer_id,
        departure_date,
        sum(shipping_cost) as daily_spend
    from logistics_shipping_dataset
    group by customer_id, departure_date
),
rolling_customer_spend as (
    select 
        customer_id,
        departure_date,
        sum(daily_spend) over (
            partition by customer_id
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as spend_7d
    from daily_customer_spend
),
ranked_customers_per_window as (
    select 
        departure_date as window_end_date,
        customer_id,
        spend_7d,
        row_number() over (
            partition by departure_date 
            order by spend_7d desc
        ) as rnk
    from rolling_customer_spend
)
select 
    window_end_date,
    customer_id as top_customer,
    spend_7d as total_7day_spend
from ranked_customers_per_window
where rnk = 1
order by window_end_date;



-- section 5: big-picture growth & cost tracking

-- q1: absolute difference in 7-day rolling revenue per origin hub

-- method 1: direct query
select 
    origin,
    departure_date,
    current_7day_rev,
    lag(current_7day_rev, 7) over (partition by origin order by departure_date) as prior_7day_rev,
    abs(current_7day_rev - lag(current_7day_rev, 7) over (partition by origin order by departure_date)) as abs_revenue_diff
from (
    select 
        origin,
        departure_date,
        sum(sum(revenue)) over (
            partition by origin
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as current_7day_rev
    from logistics_shipping_dataset
    group by origin, departure_date
) sub
order by origin, departure_date;

-- method 2: using cte
with daily_origin_rev as (
    select 
        origin,
        departure_date,
        sum(revenue) as daily_rev
    from logistics_shipping_dataset
    group by origin, departure_date
),
rolling_origin_rev as (
    select 
        origin,
        departure_date,
        sum(daily_rev) over (
            partition by origin
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as current_7day_rev
    from daily_origin_rev
)
select 
    origin,
    departure_date,
    current_7day_rev,
    lag(current_7day_rev, 7) over (partition by origin order by departure_date) as prior_7day_rev,
    abs(current_7day_rev - lag(current_7day_rev, 7) over (partition by origin order by departure_date)) as abs_revenue_diff
from rolling_origin_rev
order by origin, departure_date;


-- q2: percentage change in 7-day rolling net profit

-- method 1: direct query
select 
    departure_date,
    current_7day_profit,
    lag(current_7day_profit, 7) over (order by departure_date) as prior_7day_profit,
    round(
        ((current_7day_profit - lag(current_7day_profit, 7) over (order by departure_date))::numeric / nullif(lag(current_7day_profit, 7) over (order by departure_date), 0)) * 100, 
        2
    ) as profit_pct_change
from (
    select 
        departure_date,
        sum(sum(revenue - shipping_cost)) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as current_7day_profit
    from logistics_shipping_dataset
    group by departure_date
) sub
order by departure_date;

-- method 2: using cte
with daily_profit as (
    select 
        departure_date,
        sum(revenue - shipping_cost) as daily_net_profit
    from logistics_shipping_dataset
    group by departure_date
),
rolling_profit as (
    select 
        departure_date,
        sum(daily_net_profit) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as current_7day_profit
    from daily_profit
),
profit_lags as (
    select 
        departure_date,
        current_7day_profit,
        lag(current_7day_profit, 7) over (order by departure_date) as prior_7day_profit
    from rolling_profit
)
select 
    departure_date,
    current_7day_profit,
    prior_7day_profit,
    round(
        ((current_7day_profit - prior_7day_profit)::numeric / nullif(prior_7day_profit, 0)) * 100, 
        2
    ) as profit_pct_change
from profit_lags
order by departure_date;


-- q3: dates where 7-day rolling delayed shipments surged >20% vs. prior 7-day window

-- method 1: direct query
select departure_date, current_7day_delays, prior_7day_delays, delay_surge_pct
from (
    select 
        departure_date,
        current_7day_delays,
        lag(current_7day_delays, 7) over (order by departure_date) as prior_7day_delays,
        round(
            ((current_7day_delays - lag(current_7day_delays, 7) over (order by departure_date))::numeric / nullif(lag(current_7day_delays, 7) over (order by departure_date), 0)) * 100, 
            2
        ) as delay_surge_pct
    from (
        select 
            departure_date,
            sum(count(case when shipping_status = 'Delayed' then 1 end)) over (
                order by departure_date
                range between interval '6 days' preceding and current row
            ) as current_7day_delays
        from logistics_shipping_dataset
        group by departure_date
    ) sub1
) sub2
where prior_7day_delays > 0 and delay_surge_pct > 20.00
order by departure_date;

-- method 2: using cte
with daily_delays as (
    select 
        departure_date,
        count(case when shipping_status = 'Delayed' then 1 end) as daily_delayed_cnt
    from logistics_shipping_dataset
    group by departure_date
),
rolling_delays as (
    select 
        departure_date,
        sum(daily_delayed_cnt) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as current_7day_delays
    from daily_delays
),
delay_comparison as (
    select 
        departure_date,
        current_7day_delays,
        lag(current_7day_delays, 7) over (order by departure_date) as prior_7day_delays
    from rolling_delays
)
select 
    departure_date,
    current_7day_delays,
    prior_7day_delays,
    round(
        ((current_7day_delays - prior_7day_delays)::numeric / nullif(prior_7day_delays, 0)) * 100, 
        2
    ) as delay_surge_pct
from delay_comparison
where prior_7day_delays > 0 
  and ((current_7day_delays - prior_7day_delays)::numeric / prior_7day_delays) > 0.20
order by departure_date;


-- q4: rolling 3-month gross revenue vs. previous 3-month rolling total

-- method 1: direct query
select 
    dispatch_month,
    current_3m_revenue,
    lag(current_3m_revenue, 3) over (order by dispatch_month) as prior_3m_revenue,
    (current_3m_revenue - lag(current_3m_revenue, 3) over (order by dispatch_month)) as 3m_revenue_variance
from (
    select 
        date_trunc('month', departure_date) as dispatch_month,
        sum(sum(revenue)) over (
            order by date_trunc('month', departure_date)
            rows between 2 preceding and current row
        ) as current_3m_revenue
    from logistics_shipping_dataset
    group by date_trunc('month', departure_date)
) sub
order by dispatch_month;

-- method 2: using cte
with monthly_rev as (
    select 
        date_trunc('month', departure_date) as dispatch_month,
        sum(revenue) as monthly_revenue
    from logistics_shipping_dataset
    group by date_trunc('month', departure_date)
),
rolling_3m_rev as (
    select 
        dispatch_month,
        sum(monthly_revenue) over (
            order by dispatch_month
            rows between 2 preceding and current row
        ) as current_3m_revenue
    from monthly_rev
)
select 
    dispatch_month,
    current_3m_revenue,
    lag(current_3m_revenue, 3) over (order by dispatch_month) as prior_3m_revenue,
    (current_3m_revenue - lag(current_3m_revenue, 3) over (order by dispatch_month)) as 3m_revenue_variance
from rolling_3m_rev
order by dispatch_month;


-- q5: calendar month with highest 12-month rolling net margin

-- method 1: direct query
select 
    dispatch_month,
    rolling_12m_rev,
    rolling_12m_profit,
    round((rolling_12m_profit::numeric / nullif(rolling_12m_rev, 0)) * 100, 2) as rolling_12m_net_margin_pct
from (
    select 
        date_trunc('month', departure_date) as dispatch_month,
        sum(sum(revenue)) over (
            order by date_trunc('month', departure_date)
            rows between 11 preceding and current row
        ) as rolling_12m_rev,
        sum(sum(revenue - shipping_cost)) over (
            order by date_trunc('month', departure_date)
            rows between 11 preceding and current row
        ) as rolling_12m_profit
    from logistics_shipping_dataset
    group by date_trunc('month', departure_date)
) sub
order by rolling_12m_net_margin_pct desc
limit 1;

-- method 2: using cte
with monthly_financials as (
    select 
        date_trunc('month', departure_date) as dispatch_month,
        sum(revenue) as monthly_rev,
        sum(revenue - shipping_cost) as monthly_profit
    from logistics_shipping_dataset
    group by date_trunc('month', departure_date)
),
rolling_12m_financials as (
    select 
        dispatch_month,
        sum(monthly_rev) over (
            order by dispatch_month
            rows between 11 preceding and current row
        ) as rolling_12m_rev,
        sum(monthly_profit) over (
            order by dispatch_month
            rows between 11 preceding and current row
        ) as rolling_12m_profit
    from monthly_financials
)
select 
    dispatch_month,
    rolling_12m_rev,
    rolling_12m_profit,
    round((rolling_12m_profit::numeric / nullif(rolling_12m_rev, 0)) * 100, 2) as rolling_12m_net_margin_pct
from rolling_12m_financials
order by rolling_12m_net_margin_pct desc
limit 1;


-- q6: month-to-date operating expenses by service class (seat_class)

-- method 1: direct query
select 
    seat_class,
    departure_date,
    sum(shipping_cost) as daily_cost,
    sum(sum(shipping_cost)) over (
        partition by seat_class, date_trunc('month', departure_date)
        order by departure_date
        rows between unbounded preceding and current row
    ) as mtd_tier_operating_expense
from logistics_shipping_dataset
group by seat_class, departure_date
order by seat_class, departure_date;

-- method 2: using cte
with daily_tier_cost as (
    select 
        seat_class,
        departure_date,
        sum(shipping_cost) as daily_cost
    from logistics_shipping_dataset
    group by seat_class, departure_date
)
select 
    seat_class,
    departure_date,
    daily_cost,
    sum(daily_cost) over (
        partition by seat_class, date_trunc('month', departure_date)
        order by departure_date
        rows between unbounded preceding and current row
    ) as mtd_tier_operating_expense
from daily_tier_cost
order by seat_class, departure_date;


-- q7: mtd billed revenue per trade lane vs. prior month's total

-- method 1: direct query

select 
    m.trade_corridor,
    m.departure_date,
    m.mtd_rev,
    p.full_prior_month_rev as prior_month_total_rev,
    (m.mtd_rev - p.full_prior_month_rev) as mtd_vs_prior_month_variance
from (
    select 
        origin || ' -> ' || destination as trade_corridor,
        date_trunc('month', departure_date) as dispatch_month,
        departure_date,
        sum(sum(revenue)) over (
            partition by origin, destination, date_trunc('month', departure_date)
            order by departure_date
            rows between unbounded preceding and current row
        ) as mtd_rev
    from logistics_shipping_dataset
    group by origin, destination, departure_date
) m
left join (
    select 
        origin || ' -> ' || destination as trade_corridor,
        date_trunc('month', departure_date) as dispatch_month,
        sum(revenue) as full_prior_month_rev
    from logistics_shipping_dataset
    group by origin, destination, date_trunc('month', departure_date)
) p 
  on m.trade_corridor = p.trade_corridor 
 and p.dispatch_month = m.dispatch_month - interval '1 month'
order by m.trade_corridor, m.departure_date;

-- method 2: using cte
with monthly_corridor_rev as (
    select 
        origin || ' -> ' || destination as trade_corridor,
        date_trunc('month', departure_date) as dispatch_month,
        departure_date,
        sum(revenue) as daily_rev
    from logistics_shipping_dataset
    group by origin, destination, date_trunc('month', departure_date), departure_date
),
mtd_corridor_rev as (
    select 
        trade_corridor,
        dispatch_month,
        departure_date,
        sum(daily_rev) over (
            partition by trade_corridor, dispatch_month
            order by departure_date
            rows between unbounded preceding and current row
        ) as mtd_rev
    from monthly_corridor_rev
),
prior_month_totals as (
    select 
        origin || ' -> ' || destination as trade_corridor,
        date_trunc('month', departure_date) as dispatch_month,
        sum(revenue) as full_prior_month_rev
    from logistics_shipping_dataset
    group by origin, destination, date_trunc('month', departure_date)
)
select 
    m.trade_corridor,
    m.departure_date,
    m.mtd_rev,
    p.full_prior_month_rev as prior_month_total_rev,
    (m.mtd_rev - p.full_prior_month_rev) as mtd_vs_prior_month_variance
from mtd_corridor_rev m
left join prior_month_totals p 
  on m.trade_corridor = p.trade_corridor 
 and p.dispatch_month = m.dispatch_month - interval '1 month'
order by m.trade_corridor, m.departure_date;


-- q48: running sum resetting on gap >1 day

-- method 1: direct query
select 
    departure_date,
    daily_cnt,
    sum(daily_cnt) over (
        partition by gap_group_id
        order by departure_date
        rows between unbounded preceding and current row
    ) as running_shipments_gap_reset
from (
    select 
        departure_date,
        daily_cnt,
        sum(case when departure_date - prev_date > 1 then 1 else 0 end) over (
            order by departure_date
        ) as gap_group_id
    from (
        select 
            departure_date,
            count(shipment_id) as daily_cnt,
            lag(departure_date) over (order by departure_date) as prev_date
        from logistics_shipping_dataset
        group by departure_date
    ) sub1
) sub2
order by departure_date;

-- method 2: using cte
with date_lags as (
    select 
        departure_date,
        count(shipment_id) as daily_cnt,
        lag(departure_date) over (order by departure_date) as prev_date
    from logistics_shipping_dataset
    group by departure_date
),
gap_grouping as (
    select 
        departure_date,
        daily_cnt,
        sum(case when departure_date - prev_date > 1 then 1 else 0 end) over (
            order by departure_date
        ) as gap_group_id
    from date_lags
)
select 
    departure_date,
    daily_cnt,
    sum(daily_cnt) over (
        partition by gap_group_id
        order by departure_date
        rows between unbounded preceding and current row
    ) as running_shipments_gap_reset
from gap_grouping
order by departure_date;


-- q9: periods where 7-day volume grew for 4+ consecutive days

-- method 1: direct query
select departure_date, vol_7d as rolling_7day_volume
from (
    select 
        departure_date,
        vol_7d,
        lag(vol_7d, 1) over (order by departure_date) as d1,
        lag(vol_7d, 2) over (order by departure_date) as d2,
        lag(vol_7d, 3) over (order by departure_date) as d3,
        lag(vol_7d, 4) over (order by departure_date) as d4
    from (
        select 
            departure_date,
            sum(count(shipment_id)) over (
                order by departure_date
                range between interval '6 days' preceding and current row
            ) as vol_7d
        from logistics_shipping_dataset
        group by departure_date
    ) sub1
) sub2
where vol_7d > d1 and d1 > d2 and d2 > d3 and d3 > d4
order by departure_date;

-- method 2: using cte
with daily_vol as (
    select 
        departure_date,
        count(shipment_id) as daily_cnt
    from logistics_shipping_dataset
    group by departure_date
),
rolling_vol as (
    select 
        departure_date,
        sum(daily_cnt) over (
            order by departure_date
            range between interval '6 days' preceding and current row
        ) as vol_7d
    from daily_vol
),
trend_lags as (
    select 
        departure_date,
        vol_7d,
        lag(vol_7d, 1) over (order by departure_date) as d1,
        lag(vol_7d, 2) over (order by departure_date) as d2,
        lag(vol_7d, 3) over (order by departure_date) as d3,
        lag(vol_7d, 4) over (order by departure_date) as d4
    from rolling_vol
)
select 
    departure_date,
    vol_7d as rolling_7day_volume
from trend_lags
where vol_7d > d1 
  and d1 > d2 
  and d2 > d3 
  and d3 > d4
order by departure_date;


-- q10: route performance summary

-- method 1: direct query
select 
    origin || ' -> ' || destination as trade_corridor,
    seat_class,
    count(shipment_id) as total_shipments,
    sum(revenue) as total_revenue,
    sum(shipping_cost) as total_operating_cost,
    sum(revenue - shipping_cost) as total_net_profit,
    round(
        (sum(revenue - shipping_cost)::numeric / nullif(sum(revenue), 0)) * 100, 
        2
    ) as profit_margin_pct
from logistics_shipping_dataset
group by origin, destination, seat_class
order by total_net_profit desc;

-- method 2: using cte
with route_summary as (
    select 
        origin || ' -> ' || destination as trade_corridor,
        seat_class,
        count(shipment_id) as total_shipments,
        sum(revenue) as total_revenue,
        sum(shipping_cost) as total_operating_cost,
        sum(revenue - shipping_cost) as total_net_profit
    from logistics_shipping_dataset
    group by origin, destination, seat_class
)
select 
    trade_corridor,
    seat_class,
    total_shipments,
    total_revenue,
    total_operating_cost,
    total_net_profit,
    round((total_net_profit::numeric / nullif(total_revenue, 0)) * 100, 2) as profit_margin_pct
from route_summary
order by total_net_profit desc;


--4. Excel Reporting & Dashboard Setup

----END----




