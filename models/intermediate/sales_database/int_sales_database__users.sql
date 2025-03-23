with
    orders_summary as (
        select
            user_id,
            user_city,
            user_state,
            sum(total_order_amount) as total_amount_spent,
            sum(total_items) as total_items,
            sum(total_distinct_items) as total_distinct_items,
            count(distinct order_id) as total_orders
        from {{ ref("int_sales_db__orders") }}
        group by user_id, user_city, user_state
    )

select
    o.user_id,
    o.user_city,
    o.user_state,
    os.total_amount_spent,
    os.total_items,
    os.total_distinct_items,
    os.total_orders,
    p.favorite_product_id
from orders_summary as o
inner join orders_summary os on os.user_id = o.user_id
left join
    {{ ref("int_sales_db__user_favorite_products") }} p on o.user_id = p.user_id
