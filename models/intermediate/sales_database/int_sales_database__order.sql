with order_item_grouped_by_order as (

select order_id,
    sum(total_order_item_amount) as total_order_amount,
    sum(item_quantity) as total_items,
    count(distinct product_id) as total_distinct_items
from {{ ref('int_sales_db__order_items') }}
group by order_id

), feedback_grouped_by_order as (

select order_id,
    SUM(feedback_score) as sum_feedback_score,
    COUNT(*) as total_feedbacks
from {{ ref('stg_sales_db__feedbacks') }}
group by order_id

)

select o.order_id,
    o.user_id,
    o.order_status,
    o.order_created_at,
    o.order_approved_at,
    u.user_city,
    u.user_state,
    coalesce(f.sum_feedback_score,0) as sum_feedback_score,
    coalesce(f.total_feedbacks,0) as total_feedbacks,
    coalesce(oi.total_order_amount,0) as total_order_amount,
    coalesce(oi.total_items,0) as total_items,
    coalesce(oi.total_distinct_items,0) as total_distinct_items
from {{ ref('int_sales_db__order_items') }} as o
left join order_item_grouped_by_order as oi on o.order_id = oi.order_id
left join feedback_grouped_by_order as f on f.order_id = o.order_id
left join {{ ref('stg_sales_db__users' )}} as u on u.user_id = o.user_id
