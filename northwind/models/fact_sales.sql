with stg_orders as (
    select
        orderid,
        customerid,
        employeeid,
        replace(to_date(orderdate)::varchar,'-','')::int as orderdatekey
    from {{ source('northwind', 'Orders') }}
),

stg_order_details as (
    select
        orderid,
        productid,
        quantity,
        unitprice,
        discount,
        quantity * unitprice as extendedpriceamount,
        quantity * unitprice * discount as discountamount,
        quantity * unitprice * (1 - discount) as soldamount
    from {{ source('northwind', 'Order_Details') }}
)

select
    o.orderid,
    {{ dbt_utils.generate_surrogate_key(['o.customerid']) }} as customerkey,
    {{ dbt_utils.generate_surrogate_key(['o.employeeid']) }} as employeekey,
    o.orderdatekey,
    {{ dbt_utils.generate_surrogate_key(['od.productid']) }} as productkey,
    od.quantity,
    od.extendedpriceamount,
    od.discountamount,
    od.soldamount
from stg_orders o
join stg_order_details od on o.orderid = od.orderid
