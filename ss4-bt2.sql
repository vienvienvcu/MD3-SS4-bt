use md3_ss02;
create table customer(
   cId int auto_increment primary key,
   cName varchar(100),
   cAge int
);
create table orders (
   o_id int auto_increment primary key,
   c_id int,
   o_date datetime,
   o_totalprice double,
   constraint fk_customer foreign key (c_id)references customer(cId)
);

create table product (
   p_id int auto_increment primary key,
   p_name varchar(255),
   p_price double
);

create table order_detail(
  oid int,
  pid int,
  odquantty int,
  primary key (oid,pid),
  constraint fk_orders foreign key(oid)references orders(o_id),
  constraint fk_product foreign key(pid)references product(p_id)
);
select * from customer ;
insert into customer(cName,cAge) value ('minh quan',10);
insert into customer(cName,cAge) value ('ngoc anh',20),
                                       ('hai ha',50);


select * from product;
insert into product(p_name,p_price) value ('may giat',300);
insert into product(p_name,p_price) value ('tu lanh',500),
                                          ('dieu hoa',700),
                                          ('quat',100),
                                          ('bep dien',200),
                                          ('may hut mui',500);
                                          
  
 

insert into orders(c_id, o_date, o_totalprice) value (1,'2024-09-07',0);
insert into orders(c_id, o_date, o_totalprice) value (2,'2024-09-08',0),
                                                     (3,'2024-09-06',0);
												
insert into order_detail(oid, pid, odquantty) value (8,1,3);
insert into order_detail(oid, pid, odquantty) value (8,2,1),
                                                    (8,3,2),
                                                    (9,8,5),
                                                    (10,7,3);
update orders o
set o.o_totalprice = 
(select ifnull(sum(p.p_price * od.odquantty),0)
from order_detail od 
join product p on od.pid = p.p_id where od.oid = o.o_id
)
where o.o_totalprice is null or o.o_totalprice = 0;

select * from orders;

select * from order_detail;

-- Hiển thị tất cả customer có đơn hàng trên 150000

select c.cId,c.cName ,c.cAge ,o.o_totalprice from customer c
join orders o on c.cId = o.c_id
where o.o_totalprice >= 1500;
-- Hiển thị sản phẩm chưa được bán cho bất cứ ai

select p.p_id,p.p_name, p.p_price from product p
left join order_detail od on p.p_id = od.pid  
where od.pid is null;

-- Hiển thị tất cả đơn hàng mua trên 2 sản phẩm
  select o.o_id,o.c_id, o.o_date,o.o_totalprice from orders o
  inner join order_detail od on o.o_id = od.oid 
  group by o.o_id,o.c_id,o.o_date,o.o_totalprice 
  having count(od.pid)>=2;
  
-- Hiển thị đơn hàng có tổng giá tiền lớn nhất
  select o.o_id,o.c_id, o.o_date,o.o_totalprice from orders o
  order by o.o_totalprice desc
  limit 1;
-- Hiển thị sản phẩm có giá tiền lớn nhất

select  p.p_id,p.p_name, p.p_price from product p
order by p.p_price desc
limit 1;

-- Hiển thị người dùng nào mua nhiều sản phẩm “Bep Dien” nhất
select c.cId,c.cName,c.cAge, sum(od.odquantty) as total_quantity  from customer c
join orders o on c.cId = o.c_id
join order_detail od on o.o_id = od.oid
join product p on od.pid = p.p_id
where p_name = 'tu lanh'
group by c.cId,c.cName,c.cAge
order by total_quantity  desc
limit 1;

  
 
