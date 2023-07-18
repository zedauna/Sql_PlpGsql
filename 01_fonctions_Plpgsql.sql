---------------------------------------------------------------------------------
-- Projet : plpgslq
-- Objet du script : manipulation et proposition des fonctions
-- Auteur : Jéros VIGAN
-- Date de creation : 19/12/2017
-- Date de modification : 18/07/2023
---------------------------------------------------------------------------------

create or replace function fetcher (n integer)
returns void as $$
declare
exp record;
begin
for exp in select nom_auteur
from t_auteur
order by prenom_auteur
limit n
loop
raise notice '%',exp.nom_auteur ;
end loop;
end;
$$ language plpgsql;

select fetcher(10);

----------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR RePLACe FUNCTION total()
returns integer as $total$
declare
total integer;
begin
select count(*)into total from t_auteur;
return total;
end;
$total$ language plpgsql;

select total();

----------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR RePLACe FUNCTION mimax(a integer,b integer,c integer, out max integer, out min integer)
as $mm$
begin
max=greatest(a, b, c);
min=least(a,b,c);
end;
$mm$ language plpgsql;

select mimax(2,5,6);

----------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR RePLACe FUNCTION mimax(a integer,b integer,c integer, out max integer, out min integer)
as $mm$
begin
max=greatest(a, b, c);
min=least(a,b,c);
end;
$mm$ language plpgsql;

select mimax(2,5,6);

----------------------------------------------------------------------------------------------------------------------------------------------
/* condiction if */

do $$
declare
num1 integer=10; 
num2 integer=10;
begin
if num1>num2 then
raise notice 'num1 est superieur à num2';
end if;

if num1<num2 then
raise notice 'num1 est inferieur à num2';
end if;

if num1=num2 then
raise notice 'num1 est egal au num2';
end if ;
end$$

----------------------------------------------------------------------------------------------------------------------------------------------

do $$
declare
num1 integer=20; 
num2 integer=60;
begin
if num1>num2 then
raise notice 'num1 est superieur à num2';
else 
raise notice 'num1 est inferieur à num2';
end if;

end$$
----------------------------------------------------------------------------------------------------------------------------------------------

do $$
declare
num1 integer=50; 
num2 integer=20;
begin
if num1>num2 then
raise notice 'num1 est superieur à num2';
elseif num1<num2 then
raise notice 'num1 est inferieur à num2';
else
raise notice 'num1 est egal au num2';
end if ;
end$$

----------------------------------------------------------------------------------------------------------------------------------------------
/* boucle */

create or replace function fib (n integer)
returns integer as $$
declare
counter integer=0;
i integer=0;
j integer=1;
begin 
if (n<1) then
return 0;
end if;

loop
exit when counter=n;
counter =counter+1;
select j, j+i into i,j;
end loop;
return i;
end;
$$ language plpgsql;


select fib(6);

----------------------------------------------------------------------------------------------------------------------------------------------
create or replace function fib (n integer)
returns integer as $$
declare
counter integer=0;
i integer=0;
j integer=1;
begin 
if (n<1) then
return 0;
end if;

while counter<n loop counter =counter+1;
select j, j+i into i,j;
end loop;
return i;
end;
$$ language plpgsql;

select fib(10);
----------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR RePLACe FUNCTION req( var integer)
returns table(ident integer , nam varchar)
as $info$
begin
return query select num_auteur, nom_auteur from t_auteur
where num_auteur=var;
end;
$info$ language plpgsql;

select req(2);
----------------------------------------------------------------------------------------------------------------------------------------------

/*triggres */
create or replace function log_changer()
returns trigger as
$BODY$
begin
if NEW.adress<>OLD.adress then
insert into emp_log values(old.id, old.adress,new.adress,old.name);
end inf;
return new;
$BODY$
language plpgsql;

create trigger loc_changer
before update
on company
for each row 
execute procedure log_change();

select * from company;
update company set adress ='dehli' where id =4;
update company set adress ='dehli' where id =4;