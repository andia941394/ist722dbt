{{ config(materialized='table') }}

with
  f as (
    select * from {{ ref('fact_sales') }}
  ),

  d_customer as (
    select * from {{ ref('dim_customer') }}
  ),

  d_product as (
    select * from {{ ref('dim_product') }}
  ),

  d_date as (
    select * from {{ ref('dim_date') }}
  )

select
  f.orderid,
  f.datekey           as orderdatekey,
  f.customerkey,
  f.productkey,
  f.quantity,
  f.revenue,
  f.division,

  d_date.date         as orderdate,

  d_customer.customeremail,
  d_customer.customerfirstname,
  d_customer.customerlastname,
  d_customer.customeraddress,
  d_customer.customerzip,

  d_product.productname

from f
left join d_date     on f.datekey      = d_date.datekey
left join d_customer on f.customerkey  = d_customer.customerkey
left join d_product  on f.productkey   = d_product.productkey