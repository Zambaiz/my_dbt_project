SELECT
user_id,
product_id AS favorite_product_id
FROM {{ ref('int_sales_db__order_items') }}
GROUP BY
user_id,
product_id
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY user_id
  ORDER BY SUM(item_quantity) DESC
) = 1
