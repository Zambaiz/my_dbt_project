SELECT oi.order_id,
    order_item_id, 
    total_order_item_amount,
    item_quantity,
    product_id,
    o.user_id,
    o.order_status,
    o.order_created_at,
    o.order_approved_at
FROM
{{ ref('stg_sales_db__order_items') }} AS oi
INNER JOIN
{{ ref('stg_sales_db__orders') }} o
ON oi.order_id = o.order_id
