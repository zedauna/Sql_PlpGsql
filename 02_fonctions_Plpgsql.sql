---------------------------------------------------------------------------------
-- Projet : plpgslq
-- Objet du script : manipulation et proposition des fonctions
-- Auteur : Jéros VIGAN
-- Date de creation : 19/12/2017
-- Date de modification : 18/07/2023
---------------------------------------------------------------------------------

-- Exo 1
-- Ecrire une procédure stockée qui retourne le texte : Hello world.

DROP FUNCTION  IF EXISTS  mafonction1();
CREATE FUNCTION mafonction1 ( ) RETURNS  varchar AS $$
declare 
	
	
BEGIN
	
	RETURN 'Hello World!';
END
$$ language plpgsql;


select * from mafonction1();

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 2
-- Ecrire une procédure stockée qui retourne la date du jour au format américain.

DROP FUNCTION  IF EXISTS  mafonction2();
CREATE FUNCTION mafonction2 ( ) RETURNS  date AS $$
	
BEGIN
	
	RETURN now();
END
$$ language plpgsql;

select * from mafonction2();

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 3
-- Ecrire une procédure stockée qui retourne la date du jour au format français.

DROP FUNCTION  IF EXISTS  mafonction3();
CREATE FUNCTION mafonction3 ( ) RETURNS  varchar AS $$
declare 
	v1 date;
	v2 varchar;
BEGIN
	v1 := now();
	v2 := to_char(v1,'DD/MM/YYYY');
	RETURN v2;
END
$$ language plpgsql;


select * from mafonction3();

----------------------------------------------------------------------------------------------------------------------------------------------
-- Autre version

DROP FUNCTION  IF EXISTS  mafonction3b();
CREATE FUNCTION mafonction3b ( ) RETURNS  varchar AS $$
declare 
	v1 date;
	v2 integer;
	v3 integer;
	v4 integer;
	res varchar;
BEGIN
	v1 := now();
	v2 := extract('year' from v1);
	v3 := extract('month' from v1);
	v4 := extract('day' from v1);
	res:=v4||'/'||v3||'/'||v2;
	RETURN res;
END
$$ language plpgsql;


select * from mafonction3b();

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 4
-- Ecrire une procédure stockée à qui, partir de 2 nombres donne le résultat de la multiplication de ces 2 nombres.

DROP FUNCTION  IF EXISTS  mafonction4(integer,integer);
CREATE FUNCTION mafonction4 ( in v1 integer, in v2 integer) RETURNS  integer AS $$	
declare
	res integer;
BEGIN
	res:=v1*v2;
	RETURN res;
END
$$ language plpgsql;


select * from mafonction4(2,3);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 5
-- Ecrire une procédure stockée qui, à partir de 2 nombres entiers donne le résultat de la division du premier nombre par le second. Dans le cas où le second nombre est égal à 0 il faudra que le résultat soit le texte : Division par 0 impossible. 

DROP FUNCTION  IF EXISTS  mafonction5(integer,integer);
CREATE FUNCTION mafonction5 ( in v1 integer, in v2 integer) RETURNS  varchar AS $$
declare 
	
	msg varchar;
BEGIN
	if v2=0 then
		msg:='Division par 0 impossible';
	else
		msg:=round((v1::real/v2::real)::numeric,2);
	end if;
		
	RETURN msg;
END
$$ language plpgsql;


select * from mafonction5(801,12);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Autre version

DROP FUNCTION  IF EXISTS  mafonction5(integer,integer);
CREATE FUNCTION mafonction5 ( in v1 integer, in v2 integer) RETURNS  real AS $$
declare 
	msg real;
BEGIN
	if v2=0 then
		raise EXCEPTION 'Numéro 4802 Division par 0 impossible pour % et %',v1,v2;
	else
		msg:=round((v1::real/v2::real)::numeric,2);
	end if;
		
	RETURN msg;
END
$$ language plpgsql;


select * from mafonction5(801,0);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 6 
-- Ecrire une procédure stockée qui retourne l’appréciation d’une note selon les critères suivants :
-- Note de [0 à 4 [ : Ah !
-- Note de [4 à 8[ : Lamentable !
-- Note de [8 à 12[ : Gros progrès !
-- Note de [12 à 16[ : Oh !
-- Note de [16 à 20] : Super !
-- Note négative, note supérieure à 20 : Erreur !

-- V1 : Ecrire une version avec des instructions if

DROP FUNCTION  IF EXISTS  mafonction6a(real);
CREATE FUNCTION mafonction6a (note real) RETURNS  varchar AS $$
declare 
	msg varchar;
	
BEGIN
	if note<0 or note >20 then
		msg := 'Erreur !';
	else
		if note < 4 then
			msg:= 'Ah!' ;
		else
			if note < 8 then
				msg:= 'Lamentable!' ;
			else
				if note < 12 then
					msg:= 'Gros progrès!' ;
				else
					if note < 16 then
						msg:= 'Oh!' ;
					else	
						msg:= 'Super!' ;
					end if;
				end if;
			end if;
		end if;
	end if;
	RETURN (msg);
END
$$ language plpgsql;


select * from mafonction6a(-1);

----------------------------------------------------------------------------------------------------------------------------------------------
-- V2 : Ecrire une version avec l’instruction case

DROP FUNCTION  IF EXISTS  mafonction6b(real);
CREATE FUNCTION mafonction6b (note real) RETURNS  varchar AS $$
declare 
	msg varchar;
	
BEGIN
	case
		when note<0 or note >20 then
			msg := 'Erreur !';
		when note < 4 then
			msg:= 'Ah!' ;
		when note < 8 then
			msg:= 'Lamentable!' ;
		when note < 12 then
			msg:= 'Gros progrès!' ;
		when note < 16 then
			msg:= 'Oh!' ;
		when note <=20	then
			msg:= 'Super!' ;
	end case;
	RETURN (msg);
END
$$ language plpgsql;


select * from mafonction6b(20.1);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 7
-- Ecrire une procédure stockée qui retourne la table de multiplication par 5 sous forme de 10 lignes.

DROP FUNCTION  IF EXISTS  mafonction7();
CREATE FUNCTION mafonction7 () RETURNS SETOF varchar AS $$
declare 
	i integer;	
BEGIN
	for i in 0 .. 10 loop		
		return next (i || ' * 5 = ' || i*5);
	end loop;
	RETURN ;
END
$$ language plpgsql;

select * from mafonction7();

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 8
-- Ecrire une procédure stockée qui retourne la table de multiplication d’une valeur entière fournie en paramètre sous forme de 10 lignes. 

DROP FUNCTION  IF EXISTS  mafonction8(integer);
CREATE FUNCTION mafonction8 (v integer) RETURNS SETOF varchar AS $$
declare 
	i integer;
	
BEGIN
	for i in 1 .. 10 loop
		
		return next (i || ' * ' || v || ' = ' || i*v);
	end loop;
	RETURN;
END
$$ language plpgsql;
select * from mafonction8(6);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Améliorer en vérifiant que le nombre est une valeur positive non nulle, dans le cas contraire le résultat sera : nombre trop petit.

DROP FUNCTION  IF EXISTS  mafonction8b(integer);
CREATE FUNCTION mafonction8b (v integer) RETURNS SETOF varchar AS $$
declare 
	i integer;
	
BEGIN
	if v > 0 then
		for i in 1 .. 10 loop			
			return next (i || ' * ' || v || ' = ' || i*v);
		end loop;
	else
		return next 'Nombre trop petit';
	end if;
	RETURN;
END
$$ language plpgsql;
select * from mafonction8b(2);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 9 : Ecrire une procédure stockée qui retourne la table de multiplication d’une valeur entière fournie en paramètre sous forme d’une seule ligne.

DROP FUNCTION  IF EXISTS  mafonction9(integer);
CREATE FUNCTION mafonction9(v integer) RETURNS  varchar AS $$
declare 
	i integer;
	msg varchar;
	
BEGIN
	msg:='';
	for i in 1 .. 10 loop
		msg:=msg || i || ' * ' || v || ' = ' || i*v || '<br /> ';
	end loop;
	RETURN msg;
END
$$ language plpgsql;


select * from mafonction9(6);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 1
-- Ecrire une procédure stockée qui donne le nombre de voyelles d’un texte, sachant que le texte peut contenir n’importe quel caractère.

DROP FUNCTION  IF EXISTS  mafonction10(varchar);
CREATE FUNCTION mafonction10 (in v varchar) returns integer AS $$
declare 
	i integer;
	l integer;
	ch varchar;
	c varchar;
	nbv integer;
BEGIN
	ch= lower(v);
	l = char_length(ch);
	nbv:=0;
	for i in 1 .. l loop
		c:= substring(ch from i for 1);
		if c='a' or c='e' or c='i' or c='o' or c='u' or c='y' then
			nbv:=nbv+1;
		end if;
	end loop;
	return nbv;
	
END
$$ language plpgsql;


select * from mafonction10('he,lloM');
select  mafonction10('he,lloM');

----------------------------------------------------------------------------------------------------------------------------------------------
-- V2

DROP FUNCTION  IF EXISTS  mafonction10(varchar);
CREATE FUNCTION mafonction10 (v1 varchar) RETURNS  integer AS $$
declare 
	i integer;
	l integer;
	ch varchar;
	c varchar;
	nbv integer;
	
BEGIN
	ch=lower(v1);
	l=char_length(ch);
	nbv:=0;
	for i in 1.. l loop
		c:= substring(ch from i for 1);
		if c in ('a','e','i','o','u','y') then	
			nbv:=nbv+1;
		end if;
	end loop;
	return nbv;
END
$$ language plpgsql;


select * from mafonction10('Hello Kitty!!!!');

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 2
-- Ecrire une procédure stockée qui donne le nombre de consonnes d’un texte, sachant que le texte peut contenir n’importe quel caractère.

DROP FUNCTION  IF EXISTS  mafonction11 (varchar) ;
CREATE FUNCTION mafonction11 (in v varchar) returns integer  AS $$
declare 
	i integer;
	l integer;
	ch varchar;
	c varchar;
	nbc integer;
BEGIN
	ch= lower(v);
	l = char_length(ch);
	nbc:=0;
	for i in 1 .. l loop
		c:= substring(ch from i for 1);
		-- attention ne pas utiliser compris entre 'a' et 'z'
		if ascii(c) >=97 and ascii (c) <=122 then
			if not c in ('a','e','i','o','u','y') then
				nbc:=nbc+1;
			end if;
		end if;
	end loop;
	return nbc;
	
END
$$ language plpgsql;


select * from mafonction11('he,lloM');
select  mafonction11('he,lloM');

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 3
-- Ecrire une procédure stockée qui donne le nombre de consonnes et le nombre de voyelles d’un texte, sachant que le texte peut contenir n’importe quel caractère.
-- V1 : En écrivant l’intégralité de l’algorithme dans la procédure stockée.

DROP FUNCTION  IF EXISTS  mafonction12 (varchar,out integer,out integer);
CREATE FUNCTION mafonction12 (in v varchar, out nbv integer, out nbc integer)  AS $$
declare 
	i integer;
	l integer;
	ch varchar;
	c varchar;
BEGIN
	ch= lower(v);
	l = char_length(ch);
	nbv:=0;
	nbc=0;
	for i in 1 .. l loop
		c:= substring(ch from i for 1);
		if ascii(c) >=97 and ascii (c) <=122 then
			if c in ('a','e','i','o','u','y') then
				nbv:=nbv+1;
			else
				nbc=nbc+1;
			end if;
		end if;
	end loop;
END
$$ language plpgsql;


select * from mafonction12('hel;;;;kkk''alo,,M');

----------------------------------------------------------------------------------------------------------------------------------------------
-- V2 

DROP FUNCTION  IF EXISTS  mafonction12 (varchar,out integer,out integer);
CREATE FUNCTION mafonction12 (in v varchar, out nbv integer, out nbc integer)  AS $$
declare 
	i integer;
	l integer;
	ch varchar;
	c varchar;
BEGIN
	ch= lower(v);
	l = char_length(ch);
	nbv:=0;
	nbc=0;
	for i in 1 .. l loop
		c:= substring(ch from i for 1);
		if ascii(c) >=97 and ascii (c) <=122 then
			if c='a' or c='e' or c='i' or c='o' or c='u' or c='y' then
				nbv:=nbv+1;
			else
				nbc=nbc+1;
			end if;
		end if;
	end loop;
	
	
END
$$ language plpgsql;


select * from mafonction12('hel;;;;kkk''alo,,M');

----------------------------------------------------------------------------------------------------------------------------------------------
-- V3 : En utilisant la procédure stockée de l’activité 4. Comme il y a 2 paramètres en sortie dans la procédure stockée à utiliser il faut utiliser un curseur (cursor ou refcursor) et un enregistrement (record).

DROP FUNCTION  IF EXISTS  mafonction12b (varchar,out integer,out integer);
CREATE FUNCTION mafonction12b (in v varchar, out nbv integer, out nbc integer)  AS $$

BEGIN

	nbv:=mafonction10(v);
	nbc:=mafonction11(v);
		
END
$$ language plpgsql;


select * from mafonction12b('hel;;;;kkk''alo,,M');

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 4 : Ecrire une procédure stockée qui donne le nombre de majuscules  et le nombre de minuscules d’un texte, sachant que le texte peut contenir n’importe quel caractère.  Ne pas décomposer en 2 fonctions.

DROP FUNCTION  IF EXISTS  mafonction13(varchar,out integer,out integer);
CREATE FUNCTION mafonction13 (in ch varchar, out nbmaj integer, out nbmin integer)  AS $$
declare 
	i integer;
	l integer;

	c integer;

BEGIN

	l = char_length(ch);
	nbmaj:=0;
	nbmin:=0;
	for i in 1 .. l loop
		c:= ascii(substring(ch from i for 1));
		if c >= 65 and c<=90 then
			nbmaj:=nbmaj+1;
		elsif c >= 97and c<=122 then
			nbmin:=nbmin+1;
		end if;
	end loop;

	
END
$$ language plpgsql;


select * from mafonction13('sdfsdfHHHj') ;

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 5 
-- Ecrire une procédure stockée indique s’il y a 4 majuscules ou non dans une chaîne de caractères. Le type de retour sera boolean.
-- V1 : En écrivant l’intégralité de l’algorithme dans la procédure stockée.

DROP FUNCTION  IF EXISTS  mafonction14(varchar);
CREATE FUNCTION mafonction14 (in ch varchar) returns boolean  AS $$
declare 
	nbm integer;
	i integer;
	l integer;
BEGIN
	l = char_length(ch);
	nbm:=0;
	for i in 1 .. l loop
		if ascii(substring (ch from i for 1)) >= 65 and 
		   ascii(substring (ch from i for 1)) <= 90 then
			nbm:=nbm+1;
		end if;
	end loop;
	return nbm=4;
	
END
$$ language plpgsql;


select * from mafonction14('AA-153-BH');

----------------------------------------------------------------------------------------------------------------------------------------------
-- V2 : En utilisant la procédure stockée de l’activité 4. Comme il y a 2 paramètres en sortie dans la procédure stockée à utiliser il faut utiliser un curseur (cursor ou refcursor) et un enregistrement (record).
-- V2a : Avec un refcursor

DROP FUNCTION  IF EXISTS  mafonction14b(varchar);
CREATE FUNCTION mafonction14b (in ch varchar) returns boolean  AS $$
declare 
	curs refcursor;
	l record;
BEGIN
	open curs for select nbmaj from mafonction13(ch);
	fetch curs into l;
	return l.nbmaj=4;
END
$$ language plpgsql;


select * from mafonction14b('Aa-153-BH');

----------------------------------------------------------------------------------------------------------------------------------------------
-- V2b : Avec un cursor

DROP FUNCTION  IF EXISTS  mafonction14c(varchar);
CREATE FUNCTION mafonction14c (in ch varchar) returns boolean  AS $$
declare 

	curs cursor for select * from mafonction13(ch);
	l record;
	
BEGIN
	open curs ;
	fetch curs into l;
	return l.nbmaj=4;
END
$$ language plpgsql;


select * from mafonction14c('Aa-153-BH');

----------------------------------------------------------------------------------------------------------------------------------------------
-- V2c : Autre version avec un refcursor

DROP FUNCTION  IF EXISTS  mafonction14d(varchar, varchar);
CREATE FUNCTION mafonction14d (in ch varchar, in nom_champ varchar) returns boolean  AS $$
declare 

	-- curs cursor for select champ from mafonction13(ch);
	curs refcursor;
	l record;
	
BEGIN
	open curs for execute 'select ' || nom_champ || ' as champ from mafonction13(''' || ch || ''')';
	fetch curs into l;
	return l.champ=4;
END
$$ language plpgsql;


select * from mafonction14d('AazzAz-153-BH', 'nbmaj');

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 6 : Ecrire une procédure stockée qui donne le nombre de chiffres d’un texte, sachant que le texte peut contenir n’importe quel caractère.

DROP FUNCTION  IF EXISTS  mafonction15(varchar);
CREATE FUNCTION mafonction15 (in ch varchar) returns integer AS $$
declare 
	i integer;
	l integer;
	nbc integer;
	c integer;
BEGIN
	l := char_length(ch);
	nbc:=0;
	for i in 1 .. l loop
		c:= ascii(substring(ch from i for 1));
		if c >= 48 and c<=57 then
			nbc:= nbc+1;
		end if;
	end loop;
	return nbc;
END
$$ language plpgsql;
select * from mafonction15('he,4566;MoM');

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 7
-- Ecrire une procédure stockée indique oui ou non (boolean) si une chaîne correspond à une numéro de plaque minéralogique valide. Sachant que la forme acceptée est de la forme : 2 lettres majuscules, un tiret, 3 chiffres, un tiret et 2 lettres majuscules.
-- V1 : En écrivant l’intégralité de l’algorithme dans la procédure stockée.

DROP FUNCTION  IF EXISTS  mafonction16(varchar);
CREATE FUNCTION mafonction16 (in ch varchar) returns boolean  AS $$
declare 
	res boolean;
	cl varchar;
	cc varchar;
	i integer;
	l integer;
	
BEGIN

	l = char_length(ch);
	res=true;
	if l <> 9 then
		res:=false;
	else
		if substring(ch from 3 for 1) <> '-' or 
		   substring(ch from 7 for 1) <> '-' then
			res:= false;
		else
			cl := substring(ch from 1 for 2) || substring(ch from 8 for 2);
			cc := substring(ch from 4 for 3);
			for i in 1 .. 4 loop
				if ascii(substring (cl from i for 1)) < 65 or 
				    ascii(substring (cl from i for 1)) > 90 then
					res := false;
				end if;
			end loop;
			for i in 1 .. 3 loop
				if ascii(substring (cc from i for 1)) < 48 or 
				   ascii(substring (cc from i for 1)) > 57 then
					res := false;
				end if;
			end loop;

			
		end if;
	end if;
	return res;
	
END
$$ language plpgsql;


select * from mafonction16('ZA-153-BH');

----------------------------------------------------------------------------------------------------------------------------------------------
-- V2 : En utilisant les procédures stockées écrites précédemment à l’exclusion de celle de l’activité 5.

DROP FUNCTION  IF EXISTS  mafonction16b(varchar);
CREATE FUNCTION mafonction16b (in ch varchar) returns boolean  AS $$
declare 
	res boolean;
	cl varchar;
	cc varchar;
	i integer;
	l integer;
	curs refcursor;
	maligne record;
	
BEGIN

	l = char_length(ch);
	res=true;
	if l <> 9 then
		res:=false;
	else
		if substring(ch from 3 for 1) <> '-' or substring(ch from 7 for 1) <> '-' then
			res:= false;
		else
			cl := substring(ch from 1 for 2) || substring(ch from 8 for 2);
			cc := substring(ch from 4 for 3);
			open curs for select * from mafonction13(cl);
			fetch curs into maligne;
			close curs;
			if maligne.nbmaj<> 4 then
				res:= false;
			end if;
			open curs for select * from mafonction15(cc) as nbc;
			fetch curs into maligne;
			if maligne.nbc<> 3 then
				res:= false;
			end if;

			
		end if;
	end if;
	return res;
	
END
$$ language plpgsql;

select * from mafonction16b('Aa-153-AH');

----------------------------------------------------------------------------------------------------------------------------------------------
-- V3

DROP FUNCTION  IF EXISTS  mafonction16c(varchar);
CREATE FUNCTION mafonction16c (in ch varchar) returns boolean  AS $$
declare 
	res boolean;
	cl varchar;
	cc varchar;
	i integer;
	l integer;
	curs refcursor;
	maligne record;
	
BEGIN

	l = char_length(ch);
	res=true;
	if l <> 9 then
		res:=false;
	else
		if substring(ch from 3 for 1) <> '-' or substring(ch from 7 for 1) <> '-' then
			res:= false;
		else
			cl := substring(ch from 1 for 2) || substring(ch from 8 for 2);
			cc := substring(ch from 4 for 3);
			open curs for select * from mafonction13(cl);
			fetch curs into maligne;
			close curs;
			if maligne.nbmaj<> 4 then
				res:= false;
			end if;
			/*
			open curs for select * from mafonction15(cc) as nbc;
			fetch curs into maligne;
			if maligne.nbc<> 3 then
				res:= false;
			end if;
			*/
			if mafonction15(cc) <> 3 then
				res:= false;
			end if;
			
		end if;
	end if;
	return res;
	
END
$$ language plpgsql;


select * from mafonction16c('aA-156-bb');

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 8 
-- Ecrire une procédure stockée qui retourne la table de multiplication d’une valeur entière fournie en paramètre sous forme d’un tableau HTML. Pour tester vous écrirez le programme PHP correspondant.

DROP FUNCTION  IF EXISTS  mafonction17(integer);
CREATE FUNCTION mafonction17 (v integer) RETURNS varchar AS $$
declare 
	i integer;
	tbl varchar;
BEGIN
	tbl:='<table border="3">';
	tbl:=tbl||'<tr><td>A</td><td>B</td><td>A*B</td></tr>';
	for i in 1 .. 10 loop
		
		tbl:=tbl||('<tr><td>' || i || '</td><td>' || v || '</td><td>' || i*v || '</td></tr>');
	end loop;
	tbl:=tbl||'</table>';
	RETURN tbl;
END
$$ language plpgsql;


select * from mafonction17(6);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 9
-- Reprendre l’exercice précédent en paramétrant la largeur du tableau (ex avec 30%).

DROP FUNCTION  IF EXISTS  mafonction18(integer, varchar);
CREATE FUNCTION mafonction18 (v integer, lt varchar) RETURNS varchar AS $$
declare 
	i integer;
	tbl varchar;
BEGIN
	tbl:='<table border="3" width="'||lt||'">';
	tbl:=tbl||'<tr align="center"><td>A</td><td>B</td><td>A*B</td></tr>';
	for i in 1 .. 10 loop
		
		tbl:=tbl||('<tr align="right"><td>' || i || '</td><td>' || v || '</td><td>' || i*v || '</td></tr>');
	end loop;
	tbl:=tbl||'</table>';
	RETURN tbl;
END
$$ language plpgsql;


select mafonction18(5,'30')

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 10
-- Reprendre l’exercice précédent en paramétrant la couleur de la première ligne, et 2 autres couleurs qui serviront alternativement pour les lignes du corps.

DROP FUNCTION  IF EXISTS  mafonction19(integer, varchar, varchar, varchar, varchar);
CREATE FUNCTION mafonction19 (v integer, lt varchar, c1 varchar, c2 varchar, c3 varchar) RETURNS varchar AS $$
declare 
	i integer;
	tbl varchar;
	c varchar;
BEGIN
	tbl:='<table border="3" width="'||lt||'">';
	tbl:=tbl||'<tr bgcolor="'||c1||'" align="center"><td>A</td><td>B</td><td>A*B</td></tr>';
	for i in 1 .. 10 loop
		c:=c2;
		if i % 2 = 0 then
			c:= c3;
		end if;
		tbl:=tbl||('<tr  bgcolor="'||c||'" align="right"><td>' || i || '</td><td>' || v || '</td><td>' || i*v || '</td></tr>');
	end loop;
	tbl:=tbl||'</table>';
	RETURN tbl;
END
$$ language plpgsql;

select mafonction19(5,'30','blue','yellow','green')

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 1
-- Ecrire une procédure stockée qui donne le nombre d’images d’un internaute dont le numéro est passé en paramètre.
-- V1 : En faisant une requête sql dans la procédure stockée

DROP FUNCTION  IF EXISTS  mafonction20(int);
CREATE FUNCTION mafonction20 (in num integer) returns integer  AS $$
declare 

	curs refcursor;
	l record;
	
BEGIN
	open curs for select count(num_internaute) as nb from t_image where num_internaute=num;
	fetch curs into l;
	return l.nb;
END
$$ language plpgsql;


select * from mafonction20(2);

----------------------------------------------------------------------------------------------------------------------------------------------
-- V2 : En effectuant le calcul par programmation en parcourant toutes les lignes de la table t_image

DROP FUNCTION  IF EXISTS  mafonction20(int);
CREATE FUNCTION mafonction20 (in num integer) returns integer  AS $$
declare 

	curs cursor for select num_internaute  from t_image;
	l record;
	cpt integer;
BEGIN
	open curs ;
	cpt:=0;
	fetch curs into l;
	while (found) loop
		if l.num_internaute = num then
			cpt:=cpt+1;
		end if;
		fetch curs into l;
	end loop;
	return cpt;
END
$$ language plpgsql;


select * from mafonction20(1);

----------------------------------------------------------------------------------------------------------------------------------------------
-- V3 
DROP FUNCTION  IF EXISTS  mafonction20(int);
CREATE FUNCTION mafonction20 (in num integer) returns integer  AS $$
declare 

	curs cursor for select num_internaute  from t_image;
	l record;
	cpt integer;
BEGIN
	cpt:=0;
	for l in curs loop
		if l.num_internaute = num then
			cpt:=cpt+1;
		end if;
	end loop;
	return cpt;
END
$$ language plpgsql;


select * from mafonction20(1);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 2
-- A partir d’une procédure stockée, produire le tableau HTML suivant : Fichier - Date - Internaute / ch1.jpg - 21/09/2014 - Wopi ...

DROP FUNCTION  IF EXISTS  mafonction21();
CREATE FUNCTION mafonction21 () returns varchar  AS $$
declare 

	curs cursor for select nom_fichier, to_char(date_mel,'dd/mm/yyyy') as date_mel,  nom_internaute, prenom_internaute 
		from t_image
		inner join t_internaute on t_image.num_internaute=t_internaute.num_internaute;

	l record;
	res varchar;
BEGIN
	res:='<table border="3">';
	res:=res||'<tr><td>Fichier</td><td>Date</td><td>Internaute</td></tr>';	
	for l in curs loop	
		res:=res||'<tr><td>'||l.nom_fichier||'</td><td>'||l.date_mel||'</td><td>'||l.nom_internaute||' '||l.prenom_internaute||'</td></tr>';		
	end loop;
	res:=res||'</table>';
	return res;
END
$$ language plpgsql;


select * from mafonction21();

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 3
-- A partir d’une procédure stockée, produire le même table HTML mais qui affiche l’image au lieu de son nom.

DROP FUNCTION  IF EXISTS  mafonction21();
CREATE FUNCTION mafonction21 () returns varchar  AS $$
declare 

	curs refcursor;
	l record;
	res varchar;
BEGIN
	open curs for select nom_fichier, to_char(date_mel,'dd/mm/yyyy') as date_mel,  nom_internaute, prenom_internaute  
	from t_image
	inner join t_internaute on t_image.num_internaute=t_internaute.num_internaute;
	res:='<table border="3">';
	res:=res||'<tr><td>Fichier</td><td>Date</td><td>Internaute</td></tr>';
	fetch curs into l;
	while (found) loop	
		res:=res||'<tr><td><img src="./images/'||l.nom_fichier||'" /></td><td>'||l.date_mel||'</td><td>'||l.nom_internaute||' '||l.prenom_internaute||'</td></tr>';		
		fetch curs into l;
	end loop;
	res:=res||'</table>';
	return res;
END
$$ language plpgsql;


select * from mafonction21();

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 4 
-- Ecrire une procédure stockée, qui à partir d’un nom, d’un prénom et d’un login, ajoute un enregistrement dans la table t_internaute et qui  donne le numéro du nouvel internaute en retour.

DROP FUNCTION  IF EXISTS  mafonction23(varchar,varchar,varchar);
CREATE FUNCTION mafonction23 (in vnom varchar, in vprenom varchar, 
            in vlogin varchar) returns integer  AS $$
declare
	num integer;
BEGIN
	insert into t_internaute(nom_internaute, prenom_internaute, login) 
	     values(vnom, vprenom,vlogin) returning num_internaute into num;
	
	return num;
END
$$ language plpgsql;


select * from mafonction23('a','b','v');

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 5
-- Reprendre l’exercice précédent en vérifiant que le login n’existe pas déjà, dans ce cas la procédure stockée devra renvoyer -1.

DROP FUNCTION  IF EXISTS  mafonction23(varchar,varchar,varchar);
CREATE FUNCTION mafonction23 (in vnom varchar, in vprenom varchar, in vlogin varchar) returns integer  AS $$
declare 
	curs refcursor;
	lg record;
	num integer;
BEGIN
	open curs for select num_internaute from t_internaute where login=vlogin;
	fetch curs into lg;
	if found then
		num=-1;
	else
		insert into t_internaute(nom_internaute, prenom_internaute, login)
		    values(vnom, vprenom,vlogin) returning num_internaute into num;
	end if;
	
	return num;
END
$$ language plpgsql;


select * from mafonction23('a','b','v');

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 6
-- Ecrire une procédure stockée, qui, à partir d’une chaîne comportant un séparateur, (par exemple _) retourne plusieurs lignes composées des morceaux de chaînes se trouvant de part et d’autre du séparateur.
-- Par exemple avec la chaîne a_b_c_dd ou la chaîne __a_b____c_dd__  la procédure stockée devra retourner 4 lignes : a puis b puis c et dd
-- V1

DROP FUNCTION  IF EXISTS  mafonction24a(varchar,varchar);
CREATE FUNCTION mafonction24a (in ch varchar, in sep varchar) returns setof varchar  AS $$
declare 
	pos integer;
	l integer;
	sch varchar;
BEGIN
	
	pos=-1;
	while pos<>0 loop
		pos = position(sep in ch);
		l=char_length(ch);
		if pos <> 0 then
			sch := substring(ch from 1 for pos-1);
		else
			sch := ch;
		end if;
		if char_length(sch) <>0 then
			return next sch;
		end if;
		ch:= substring(ch from pos+1  for l-pos);
	end loop;
END
$$ language plpgsql;


select * from mafonction24a('____a_b_c_dd___','_');

----------------------------------------------------------------------------------------------------------------------------------------------
-- V2

DROP FUNCTION  IF EXISTS  mafonction24c(varchar,varchar);
CREATE FUNCTION mafonction24c (in ch varchar, in sep varchar) returns table (v text)  AS $$
declare 
	
BEGIN
	return query select * from regexp_split_to_table(ch,sep);
END
$$ language plpgsql;


select * from mafonction24c('___aa_b_c_dd_e__','_');

--select * from regexp_split_to_table('__aa_b_c_dd__','_')

----------------------------------------------------------------------------------------------------------------------------------------------
-- V3

DROP FUNCTION  IF EXISTS  mafonction24b(varchar,varchar);
CREATE FUNCTION mafonction24b (in ch varchar, in sep varchar) returns setof varchar  AS $$
declare 
	curs refcursor;
	l record;
BEGIN
	open curs for select * from regexp_split_to_table(ch,sep) as v;
	fetch curs into l;
	while found loop
		if l.v <> '' then
			return next l.v;
		end if;
		fetch curs into l;
	end loop;
END
$$ language plpgsql;


select * from mafonction24b('___aa_b____c_dd___','_');

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 8
-- Ecrire une procédure stockée qui affiche le même tableau HTML qu’à l’activité 2 sauf que pour la dernière colonne on affichera soit le nom soit le login. 
-- Pour cela c’est le nom de la colonne (login ou nom_internaute) qui sera paramétré.
-- V1 : Avec une condition pour générer la bonne requête SQL

DROP FUNCTION  IF EXISTS  mafonction26(varchar);
CREATE FUNCTION mafonction26 (in col varchar) returns varchar  AS $$
declare 

	curs refcursor;
	l record;
	res varchar;
BEGIN
	if col = 'login' then
		open curs for select nom_fichier, to_char(date_mel,'dd/mm/yyyy') as date_mel,  login  as c3
				from t_image
				inner join t_internaute on t_image.num_internaute=t_internaute.num_internaute;
	else
		open curs for select nom_fichier, to_char(date_mel,'dd/mm/yyyy') as date_mel,  nom_internaute  as c3
				from t_image
				inner join t_internaute on t_image.num_internaute=t_internaute.num_internaute;
	end if;

	res:='<table border="3">';
	res:=res||'<tr><td>Fichier</td><td>Date</td><td>Internaute</td></tr>';
	fetch curs into l;
	while (found) loop	
		res:=res||'<tr><td>'||l.nom_fichier||'</td><td>'||l.date_mel||'</td><td>'||l.c3||'</td></tr>';		
		fetch curs into l;
	end loop;
	res:=res||'</table>';
	return res;
END
$$ language plpgsql;


select * from mafonction26('login');

----------------------------------------------------------------------------------------------------------------------------------------------
-- V2 : Utilisation du mot clé execute pour construire la bonne requête sans condition. 
-- Attention, lorsqu’une chaîne plpgsql contient des apostrophes (’) il faut les doubler (’’  pas guillemets).

DROP FUNCTION  IF EXISTS  mafonction26(varchar);
CREATE FUNCTION mafonction26 (in col varchar) returns varchar  AS $$
declare 

	curs refcursor;
	l record;
	res varchar;
BEGIN
	
		open curs for execute 'select nom_fichier, to_char(date_mel,''dd/mm/yyyy'') as date_mel, 
		        ' || col || '  as c3
				from t_image
				inner join t_internaute on t_image.num_internaute=t_internaute.num_internaute';


	res:='<table border="3">';
	res:=res||'<tr><td>Fichier</td><td>Date</td><td>Internaute</td></tr>';
	fetch curs into l;
	while (found) loop	
		res:=res||'<tr><td>'||l.nom_fichier||'</td><td>'||l.date_mel||'</td><td>'||l.c3||'</td></tr>';		
		fetch curs into l;
	end loop;
	res:=res||'</table>';
	return res;
END
$$ language plpgsql;


select * from mafonction26('login');

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 1
-- Ecrire un trigger qui lorsqu’une insertion dans la table t_theme est effectuée, vérifie, aux minuscules, majuscules près que le nom du thème n’existe pas déjà.
-- Dans le cas où celui-ci existerait une erreur avec le message « Thème existant » devra être générée.

DROP  FUNCTION   IF EXISTS  mafonction41() CASCADE;
CREATE FUNCTION mafonction41 () returns TRIGGER  AS $$
declare
	curs refcursor;
	l record;
	t varchar;
	
BEGIN
	t:=lower(NEW.nom_theme);
	open curs for select num_theme from t_theme 
	    where lower(nom_theme)=t;
	fetch curs into l;
	if found then
		raise exception 'Thème existant';
		return null;
	else
		NEW.nom_theme:=t;
		return NEW;
	end if;
	
END
$$ language plpgsql;

create trigger test_exo1 BEFORE INSERT ON t_theme
     FOR EACH ROW
     EXECUTE PROCEDURE mafonction41();

insert into t_theme(nom_theme) values('C') returning nom_theme;

----------------------------------------------------------------------------------------------------------------------------------------------
-- Exo 2
-- Dans la table t_theme, vous rajouterez le champ calculé « nb_image » de type entier qui indiquera pour chaque thème le nombre d’images lui étant consacré.
-- Vous modifierez le trigger précédent pour que, lorsque l’on insère un nouveau thème en donnant uniquement son nom, le champ « nb_image » soit valorisé à 0.


DROP  FUNCTION   IF EXISTS  mafonction41() CASCADE;
CREATE FUNCTION mafonction41 () returns TRIGGER  AS $$
declare
	curs refcursor;
	l record;
	t varchar;
	
BEGIN
	t:=lower(NEW.nom_theme);
	open curs for select num_theme from t_theme where lower(nom_theme)=t;
	fetch curs into l;
	if found then
		raise exception 'Thème existant';
		return null;
	else
		NEW.nom_theme:=t;
		NEW.nb_image=0;
		return NEW;
	end if;
	
END
$$ language plpgsql;

create trigger test_exo1 BEFORE INSERT ON t_theme
     FOR EACH ROW
     EXECUTE PROCEDURE mafonction41();

insert into t_theme(nom_theme) values('e') returning nom_theme;

----------------------------------------------------------------------------------------------------------------------------------------------
--Exo 3
-- Ecrire un trigger qui lorsqu’une insertion dans la table t_correspondre est effectuée, augmente de 1 le compteur d’image de la table t_theme correspondant.

DROP  FUNCTION   IF EXISTS  mafonction43() CASCADE;
CREATE FUNCTION mafonction43 () returns TRIGGER  AS $$
declare
	
	
BEGIN
	update t_theme set nb_image=nb_image+1 
	where num_theme=NEW.num_theme;
	return NEW;
	
END
$$ language plpgsql;

create trigger test_exo3 after INSERT ON t_correspondre
     FOR EACH ROW
     EXECUTE PROCEDURE mafonction43();

insert into t_correspondre(num_theme,num_image) values(7,2) 


----------------------------------------------------------------------------------------------------------------------------------------------
/* 1. Créer une procédure stockée, attendant un login et un mot de passe et qui donne le numéro de client correspondant ou -1 le cas échéant. */

DROP FUNCTION  IF EXISTS  verif_login(varchar,varchar);
CREATE FUNCTION verif_login (in vlogin varchar, in vmdp varchar) returns integer  AS $$
declare 
	curs refcursor;
	lg record;
	res integer;
BEGIN
	open curs for select num_client from t_client where login=vlogin and mdp=vmdp;
	fetch curs into lg;
	res=-1;
	if found then
		res:=lg.num_client;
	end if;
	return res;
END
$$ language plpgsql;


select * from verif_login('a','ba') ;

----------------------------------------------------------------------------------------------------------------------------------------------
/* 2. Créer une procédure stockée, qui à partir d’un numéro de client crée un panier pour celui-ci et donne le numéro de panier nouvellement créé */

DROP FUNCTION  IF EXISTS  creer_panier(integer);
CREATE FUNCTION creer_panier (in numc integer) returns integer  AS $$
declare 
	num integer;
BEGIN
	insert into t_panier (num_client) values(numc) returning num_panier into num;
	return(num);
END
$$ language plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------------
/* 3. Créer un déclencheur qui, lorsque l’on crée un nouveau panier, nettoie, en terme de panier, ce qu’il y avait anciennement pour ce client. */

DROP  FUNCTION   IF EXISTS  ps_creer_panier() CASCADE;
CREATE FUNCTION ps_creer_panier() returns TRIGGER  AS $$
declare
	nump integer;
	numc integer;
	nump2 integer;
	curs refcursor;
	ligne record;
	
BEGIN
	nump = NEW.num_panier;
	numc = NEW.num_client;
	open curs for select num_panier from t_panier where num_client=numc and num_panier < nump;
	fetch curs into ligne;
	while found loop
		nump2=ligne.num_panier;
		delete from t_ligne_panier where num_panier = nump2;
		fetch curs into ligne;
	end loop;
	
	delete from t_panier where num_client=numc and num_panier < nump;
	return null;
	
END
$$ language plpgsql;

create trigger tg_creer_panier after INSERT ON t_panier
     FOR EACH ROW
     EXECUTE PROCEDURE ps_creer_panier();

----------------------------------------------------------------------------------------------------------------------------------------------
/* 4. Ecrire une procédure stockée qui, à partir d’un numéro de produit, d’un numéro de panier et d’une quantité, met à jour le panier. 
 * Dans le cas où le produit n’est pas dans le panier, une nouvelle ligne de panier devra être créée dans le cas contraire, la quantité devra être mise à jour. */

DROP FUNCTION  IF EXISTS  ajouter_ligne_panier(integer, integer, integer);
CREATE FUNCTION ajouter_ligne_panier (in nump integer, in qte integer, in panier integer) returns integer AS $$
declare 
	curs refcursor;
	l record;
	q integer
BEGIN
	open curs for select * from t_ligne_panier where num_panier=panier and num_produit=nump;
	fetch curs into l;
	if found then
		q:=l.qte+qte;
		update t_ligne_panier set qte= q where num_panier=panier and num_produit=nump;
	else
		q:= qte;
		insert into t_ligne_panier values (panier,nump,q) ;
	end if;
	return 0;
END
$$ language plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------------
/* 5. Ecrire un déclencheur qui, lorsque la colonne stock de la table t_produit est modifiée, et que si ce stock devient négatif, il devra être remis à 0. */

DROP  FUNCTION   IF EXISTS  ps_maj_stock() CASCADE;
CREATE FUNCTION ps_maj_stock() returns TRIGGER  AS $$
declare
	
	
BEGIN
	
	if NEW.stock < 0 then
		NEW.stock=0;
	end if;

	return NEW;
	
END
$$ language plpgsql;

create trigger tg_maj_stock before UPDATE OF stock ON t_produit 
     FOR EACH ROW
     EXECUTE PROCEDURE ps_maj_stock();

----------------------------------------------------------------------------------------------------------------------------------------------
/* 5.v2 */

DROP  FUNCTION   IF EXISTS  ps_maj_stock() CASCADE;
CREATE FUNCTION ps_maj_stock() returns TRIGGER  AS $$
declare
	
	
BEGIN
	
	if NEW.stock < 0 then
		NEW.stock=0;
	end if;

	return NEW;
	
END
$$ language plpgsql;

create trigger tg_maj_stock before UPDATE OF stock ON t_produit 
     FOR EACH ROW
     EXECUTE PROCEDURE ps_maj_stock();

----------------------------------------------------------------------------------------------------------------------------------------------
/* 6. Ecrire une grosse procédure stockée qui, à partir d’un numéro de panier, permet de valider ce panier. Les actions qui devront être faites sont les suivantes :
a.	Récupération du numéro de client pour ce panier
b.	Création d’une commande pour ce client avec la date du jour
c.	Pour chaque ligne du panier:
	i.	créer une ligne de commande
	ii.	mettre à jour le stock 
d.	nettoyer le panier
e.	Produite un tableau HTML de synthèse de la commande (cf écran 7). */

DROP FUNCTION  IF EXISTS valider_panier(integer);
CREATE FUNCTION valider_panier (in nump integer) returns varchar AS $$
declare 
	curs refcursor;
	l record;
	numcom integer;
	numcli integer;
	res varchar;
	dispo varchar;
	delai varchar;
	ht real;
	tht real;
	ttc real;
	
BEGIN
	open curs for select num_client from t_panier where num_panier=nump;
	fetch curs into l;
	numcli := l.num_client;
	close curs;

	insert into t_commande (num_client, date_commande) values(numcli, now()) returning num_commande into numcom;
	
	open curs for select  t_produit.num_produit, qte, ref_produit, designation,stock, prix, delai_stock, delai_hors_stock,qte
	      from t_produit, t_panier, t_ligne_panier
	      where t_produit.num_produit=t_ligne_panier.num_produit
	      and t_panier.num_panier=t_ligne_panier.num_panier
	      and t_panier.num_panier=nump;
	    
	fetch curs into l;
	tht:=0;
	res:='<h1>Numéro de commande : '||numcom||' </h1>';
	res:=res||'<h2>En date du : '||to_char(now(),'dd/mm/yyyy')||' </h1>';
	res := res|| '<table border="3">';
	res := res || '<tr align="center"><td>Référence</td><td>Désignation</td><td>Prix</td><td>Quantité</td><td>HT</td><td>TTC</td><td>Disponibilité</td></tr>';
	while found loop
		dispo := 'il reste '||l.stock||' exemplaire(s)';
		delai = l.delai_stock;
		if l.stock=0 then
			dispo := 'réapprovisionnement en cours';
			delai := l.delai_hors_stock;
		end if;
		ht:=l.prix*l.qte;
		tht:=tht+ht;
		ttc:=ht*1.20;
		res:=res||'<tr><td>'||l.ref_produit||'</td><td>'||l.designation||'</td><td align="right">'||l.prix||
			' €</td><td align="right">'||l.qte||'</td><td align="right">'||ht||' €</td><td align="right">'||ttc||
			' €</td><td>'||dispo||'</td></tr>';
		insert into t_ligne_commande(num_commande,num_produit,qte) values (numcom,l.num_produit, l.qte);
		update t_produit set stock = stock - l.qte where num_produit = l.num_produit;
		fetch curs into l;	
	end loop;
	res:=res||'<tr><td colspan="5">Total HT</td><td align="right">'||tht||' €</td><td></td></tr>';
	res:=res||'<tr><td colspan="5">TVA</td><td align="right">'||(tht * 0.20)||' €</td><td></td></tr>';
	res:=res||'<tr><td colspan="5">Total TTC</td><td align="right">'||(tht * 1.20)||' €</td><td></td></tr>';
	delete from t_ligne_panier where num_panier=nump;
	delete from t_panier where num_panier=nump;
	res := res || '</table>';
	return res;
END
$$ language plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------------
-- verification de login

DROP FUNCTION  IF EXISTS  verif_login(varchar,varchar);
CREATE FUNCTION verif_login (in vlogin varchar, in vmdp varchar) returns integer  AS $$
declare 
	curs refcursor;
	lg record;
	res integer;
BEGIN
	open curs for select num_client from t_client where login=vlogin and mdp=vmdp;
	fetch curs into lg;
	res=-1;
	if found then
		res:=lg.num_client;
	end if;
	return res;
END
$$ language plpgsql;


select * from verif_login('a','ba') ;

----------------------------------------------------------------------------------------------------------------------------------------------
-- validation de son panier

DROP FUNCTION  IF EXISTS valider_panier(integer);
CREATE FUNCTION valider_panier (in nump integer) returns varchar AS $$
declare 
	curs refcursor;
	l record;
	numcom integer;
	numcli integer;
	res varchar;
	dispo varchar;
	delai varchar;
	ht real;
	tht real;
	ttc real;
	
BEGIN
	open curs for select num_client from t_panier where num_panier=nump;
	fetch curs into l;
	numcli := l.num_client;
	close curs;

	insert into t_commande (num_client, date_commande) values(numcli, now()) returning num_commande into numcom;
	
	open curs for select  t_produit.num_produit, qte, ref_produit, designation,stock, prix, delai_stock, delai_hors_stock,qte
	      from t_produit, t_panier, t_ligne_panier
	      where t_produit.num_produit=t_ligne_panier.num_produit
	      and t_panier.num_panier=t_ligne_panier.num_panier
	      and t_panier.num_panier=nump;
	    
	fetch curs into l;
	tht:=0;
	res:='<h1>Numéro de commande : '||numcom||' </h1>';
	res:=res||'<h2>En date du : '||to_char(now(),'dd/mm/yyyy')||' </h1>';
	res := res|| '<table border="3">';
	res := res || '<tr align="center"><td>Référence</td><td>Désignation</td><td>Prix</td><td>Quantité</td><td>HT</td><td>TTC</td><td>Disponibilité</td></tr>';
	while found loop
		dispo := 'il reste '||l.stock||' exemplaire(s)';
		delai = l.delai_stock;
		if l.stock=0 then
			dispo := 'réapprovisionnement en cours';
			delai := l.delai_hors_stock;
		end if;
		ht:=l.prix*l.qte;
		tht:=tht+ht;
		ttc:=ht*1.20;
		res:=res||'<tr><td>'||l.ref_produit||'</td><td>'||l.designation||'</td><td align="right">'||l.prix||
			' €</td><td align="right">'||l.qte||'</td><td align="right">'||ht||' €</td><td align="right">'||ttc||
			' €</td><td>'||dispo||'</td></tr>';
		insert into t_ligne_commande(num_commande,num_produit,qte) values (numcom,l.num_produit, l.qte);
		update t_produit set stock = stock - l.qte where num_produit = l.num_produit;
		fetch curs into l;	
	end loop;
	res:=res||'<tr><td colspan="5">Total HT</td><td align="right">'||tht||' €</td><td></td></tr>';
	res:=res||'<tr><td colspan="5">TVA</td><td align="right">'||(tht * 0.20)||' €</td><td></td></tr>';
	res:=res||'<tr><td colspan="5">Total TTC</td><td align="right">'||(tht * 1.20)||' €</td><td></td></tr>';
	delete from t_ligne_panier where num_panier=nump;
	delete from t_panier where num_panier=nump;
	res := res || '</table>';
	return res;
END
$$ language plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------------
--trigger

DROP  FUNCTION   IF EXISTS  ps_maj_stock() CASCADE;
CREATE FUNCTION ps_maj_stock() returns TRIGGER  AS $$
declare
	
	
BEGIN
	
	if NEW.stock < 0 then
		NEW.stock=0;
	end if;

	return NEW;
	
END
$$ language plpgsql;

create trigger tg_maj_stock before UPDATE OF stock ON t_produit 
     FOR EACH ROW
     EXECUTE PROCEDURE ps_maj_stock();

----------------------------------------------------------------------------------------------------------------------------------------------
DROP  FUNCTION   IF EXISTS  ps_maj_stock() CASCADE;
CREATE FUNCTION ps_maj_stock() returns TRIGGER  AS $$
declare
	
	
BEGIN
	
	if NEW.stock < 0 then
		NEW.stock=0;
	end if;

	return NEW;
	
END
$$ language plpgsql;

create trigger tg_maj_stock before UPDATE OF stock ON t_produit 
     FOR EACH ROW
     EXECUTE PROCEDURE ps_maj_stock();

----------------------------------------------------------------------------------------------------------------------------------------------
DROP  FUNCTION   IF EXISTS  ps_creer_panier() CASCADE;
CREATE FUNCTION ps_creer_panier() returns TRIGGER  AS $$
declare
	nump integer;
	numc integer;
	nump2 integer;
	curs refcursor;
	ligne record;
	
BEGIN
	nump = NEW.num_panier;
	numc = NEW.num_client;
	open curs for select num_panier from t_panier where num_client=numc and num_panier < nump;
	fetch curs into ligne;
	while found loop
		nump2=ligne.num_panier;
		delete from t_ligne_panier where num_panier = nump2;
		fetch curs into ligne;
	end loop;
	
	delete from t_panier where num_client=numc and num_panier < nump;
	return null;
	
END
$$ language plpgsql;

create trigger tg_creer_panier after INSERT ON t_panier
     FOR EACH ROW
     EXECUTE PROCEDURE ps_creer_panier();

----------------------------------------------------------------------------------------------------------------------------------------------
--creation d'une table

DROP FUNCTION  IF EXISTS  creer_panier(integer);
CREATE FUNCTION creer_panier (in numc integer) returns integer  AS $$
declare 
	num integer;
BEGIN
	insert into t_panier (num_client) values(numc) returning num_panier into num;
	return(num);
END
$$ language plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------------
--ajout ligne au panier

DROP FUNCTION  IF EXISTS  ajouter_ligne_panier(integer, integer, integer);
CREATE FUNCTION ajouter_ligne_panier (in nump integer, in qte integer, in panier integer) returns integer AS $$
declare 
	curs refcursor;
	l record;
	q integer
BEGIN
	open curs for select * from t_ligne_panier where num_panier=panier and num_produit=nump;
	fetch curs into l;
	if found then
		q:=l.qte+qte;
		update t_ligne_panier set qte= q where num_panier=panier and num_produit=nump;
	else
		q:= qte;
		insert into t_ligne_panier values (panier,nump,q) ;
	end if;
	return 0;
END
$$ language plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION  IF EXISTS  mafonction1(varchar);
CREATE FUNCTION mafonction1 (in v varchar) returns integer AS $$
declare 
	i integer;
	l integer;
	ch varchar;
	c varchar;
	nbv integer;
BEGIN
	ch= lower(v);
	l = char_length(ch);
	nbv:=0;
	for i in 1 .. l loop
		c:= substring(ch from i for 1);
		if c='a' or c='e' or c='i' or c='o' or c='u' or c='y' then
			nbv:=nbv+1;
		end if;
	end loop;
	return nbv;
	
END
$$ language plpgsql;


select * from mafonction1('he,lloM');
select  mafonction1('he,lloM');

----------------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION  IF EXISTS  mafonction2 (varchar) ;
CREATE FUNCTION mafonction2 (in v varchar) returns integer  AS $$
declare 
	i integer;
	l integer;
	ch varchar;
	c varchar;
	nbc integer;
BEGIN
	ch= lower(v);
	l = char_length(ch);
	nbc:=0;
	for i in 1 .. l loop
		c:= substring(ch from i for 1);
		-- attention ne pas utiliser compris entre 'a' et 'z'
		if ascii(c) >=97 and ascii (c) <=122 then
			if not c in ('a','e','i','o','u','y') then
				nbc:=nbc+1;
			end if;
		end if;
	end loop;
	return nbc;
	
END
$$ language plpgsql;

select mafonction2('je viens de la cité')

----------------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION  IF EXISTS  mafonction3a (varchar,out integer,out integer);
CREATE FUNCTION mafonction3a (in v varchar, out nbv integer, out nbc integer)  AS $$
declare 
	i integer;
	l integer;
	ch varchar;
	c varchar;
BEGIN
	ch= lower(v);
	l = char_length(ch);
	nbv:=0;
	nbc=0;
	for i in 1 .. l loop
		c:= substring(ch from i for 1);
		if ascii(c) >=97 and ascii (c) <=122 then
			if c in ('a','e','i','o','u','y') then
				nbv:=nbv+1;
			else
				nbc=nbc+1;
			end if;
		end if;
	end loop;
	
	
END
$$ language plpgsql;


select * from mafonction3a('hel;;;;kkk''alo,,M');

----------------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION  IF EXISTS  mafonction3b (varchar,out integer,out integer);
CREATE FUNCTION mafonction3b (in v varchar, out nbv integer, out nbc integer)  AS $$

BEGIN

	nbv:=mafonction1(v);
	nbc:=mafonction2(v);
		
END
$$ language plpgsql;


select * from mafonction3b('hel;;;;kkk''alo,,M');


DROP FUNCTION  IF EXISTS  mafonction4a(varchar);
CREATE FUNCTION mafonction4a (in ch varchar) returns boolean  AS $$
declare 
	nbm integer;
	i integer;
	l integer;
BEGIN
	l = char_length(ch);
	nbm:=0;
	for i in 1 .. l loop
		if ascii(substring (ch from i for 1)) >= 65 and 
		   ascii(substring (ch from i for 1)) <= 90 then
			nbm:=nbm+1;
		end if;
	end loop;
	return nbm=4;
	
END
$$ language plpgsql;

select * from mafonction4a('AA-153-BH');

----------------------------------------------------------------------------------------------------------------------------------------------

DROP FUNCTION  IF EXISTS  mafonction4b(varchar,out integer,out integer);
CREATE FUNCTION mafonction4b (in ch varchar, out nbmaj integer, out nbmin integer)  AS $$
declare 
	i integer;
	l integer;

	c integer;

BEGIN

	l = char_length(ch);
	nbmaj:=0;
	nbmin:=0;
	for i in 1 .. l loop
		c:= ascii(substring(ch from i for 1));
		if c >= 65 and c<=90 then
			nbmaj:=nbmaj+1;
		elsif c >= 97and c<=122 then
			nbmin:=nbmin+1;
		end if;
	end loop;

	
END
$$ language plpgsql;


select * from mafonction4b('sdfsdfHHHj') ;

----------------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION  IF EXISTS  mafonction5a(varchar);
CREATE FUNCTION mafonction5a (in ch varchar) returns boolean  AS $$
declare 
	res boolean;
	cl varchar;
	cc varchar;
	i integer;
	l integer;
	
BEGIN

	l = char_length(ch);
	res=true;
	if l <> 9 then
		res:=false;
	else
		if substring(ch from 3 for 1) <> '-' or 
		   substring(ch from 7 for 1) <> '-' then
			res:= false;
		else
			cl := substring(ch from 1 for 2) || substring(ch from 8 for 2);
			cc := substring(ch from 4 for 3);
			for i in 1 .. 4 loop
				if ascii(substring (cl from i for 1)) < 65 or 
				    ascii(substring (cl from i for 1)) > 90 then
					res := false;
				end if;
			end loop;
			for i in 1 .. 3 loop
				if ascii(substring (cc from i for 1)) < 48 or 
				   ascii(substring (cc from i for 1)) > 57 then
					res := false;
				end if;
			end loop;

			
		end if;
	end if;
	return res;
	
END
$$ language plpgsql;


select * from mafonction5a('ZA-153-BH');

----------------------------------------------------------------------------------------------------------------------------------------------

DROP FUNCTION  IF EXISTS  mafonction5b(varchar);
CREATE FUNCTION mafonction5b (in ch varchar) returns boolean  AS $$
declare 
	res boolean;
	cl varchar;
	cc varchar;
	i integer;
	l integer;
	curs refcursor;
	maligne record;
	
BEGIN

	l = char_length(ch);
	res=true;
	if l <> 9 then
		res:=false;
	else
		if substring(ch from 3 for 1) <> '-' or substring(ch from 7 for 1) <> '-' then
			res:= false;
		else
			cl := substring(ch from 1 for 2) || substring(ch from 8 for 2);
			cc := substring(ch from 4 for 3);
			open curs for select * from mafonction4b(cl);
			fetch curs into maligne;
			close curs;
			if maligne.nbmaj<> 4 then
				res:= false;
			end if;
			open curs for select * from mafonction5a(cc) as nbc;
			fetch curs into maligne;
			if maligne.nbc<> 3 then
				res:= false;
			end if;

			
		end if;
	end if;
	return res;
	
END
$$ language plpgsql;


select * from mafonction5b('Aa-153-AH');

----------------------------------------------------------------------------------------------------------------------------------------------

CREATE FUNCTION test() returns varchar  AS $$
declare 

    curs moncursor;
    monrecord record;
    resultat varchar;
BEGIN
    open curs for select la requête à faire qui contient les 2 champs à afficher et les 3 tables à joindre;
    res:='mettre les entêtes';
    fetch moncurs into monrecord;
    while (found) loop
        res:ultat=resultat'<tr><td>'moncurseur.nom_fichier'</td><td>'moncurseur.date_mel'</td></td></tr>';
        fetch moncurs into monrecord;
    end loop;
    resultat:=resultat'</table>';
    return resultat;
END
$$ language plpgsql;


create function mon_schema.liste_tte_bdqq_2 (character)
returns table(nom name) 
as $$
begin
return query select datname from pg_database where datname like concat($1,'%');
end;
$$ language plpgsql;

select mon_schema.liste_tte_bdqq_2 ('c');

----------------------------------------------------------------------------------------------------------------------------------------------

create function mon_schema.liste_tte_bdqq_4 (character varying)
returns table(nom name) 
as $$
begin
return query select datname from pg_database where datname like $1 || '%';
end;
$$ language plpgsql;

select mon_schema.liste_tte_bdqq_4 ('c');


create function mon_schema.creeindex (character,character,character)
returns void
as $$
begin 
execute 'create index '||$1||' on '||$2||' ('||$3||')';
end;
$$ language plpgsql;


create function ajouteutilgroupe (character, character)
returns text
as
$$
begin
raise info 'coucou on a ajoute la personne%',$1;
execute 'grant ' ||$2 ||' to '||$1 ;
return 'fini utilisateur' || $1; 
end;
$$
language plpgsql;

select ajouteutilgroupe('visiteur_jf','gpv_pandoupy')

----------------------------------------------------------------------------------------------------------------------------------------------

/*enlève un utilisateur d’un groupe. Le nom du groupe et de l’utilisateur sont passés en paramètre*/
create function enleverutil(character varying, character varying) returns text	as
$$
Begin
Execute 'revoke '||$1||' from '||$2;
return 'fini chef';
end;
$$ language plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------------
/* commande administrateur quelconque sans paramètre.   */

CREATE OR REPLACE FUNCTION savoir(character varying) RETURNS void as 
$$
begin
EXECUTE $1;
end
$$ language plpgsql;

SELECT savoir('select * from pg_roles');

----------------------------------------------------------------------------------------------------------------------------------------------
/* commande administrateur quelconque sans paramètre.   */

CREATE OR REPLACE FUNCTION savoirT(character varying) RETURNS TABLE (mon name) as 
$$
begin
RETURN QUERY select ||$1;
end
$$ language plpgsql;

SELECT savoirT('rolname from pg_admin');

----------------------------------------------------------------------------------------------------------------------------------------------
/* l’utilisateur courant a le droit donné en paramètre sur la table dont le nom est donné en 2ième paramètre   */

CREATE OR REPLACE FUNCTION droitscourant(character varying,character varying) RETURNS text as 
$$
begin
RETURN has_table_privilege($1, $2);
end
$$ language plpgsql;

select droitscourant('famille','SELECT');

OU
create function droitscourant1(character varying, character varying) returns table (matable Boolean)as
$$
Begin
Return query select  has_table_privilege($1,$2);
end;
$$ language plpgsql;

Select droitscourant1(‘famille’,’select’) ;

----------------------------------------------------------------------------------------------------------------------------------------------
/*l’utilisateur dont le nom est passé en 1ier paramètre a le droit donné en 2ièmeparamètre sur la table dont le nom est donné en 3ième paramètre.   */
CREATE OR REPLACE  FUNCTION droitsutilT (character varying,character varying,character varying) RETURNS text as 
$$
begin
RETURN has_table_privilege($1, $2, $3);
end
$$ language plpgsql;

OU

create function droitsutilT1(character varying, character varying, character varying) returns table (matable Boolean)as
$$
Begin
Return query select  has_table_privilege($1,$2,$3);
end;
$$ language plpgsql;

Select droitsutil1(‘posgres’,‘famille’,’select’) ;

----------------------------------------------------------------------------------------------------------------------------------------------
/*si l’utilisateur dont le nom est passé en 1ier paramètre a le droit donné en 2ièmeparamètre sur la BDD dont le nom est donné en 3ième paramètre.*/

SELECT has_database_privilege('jeros_jardiner','CREATE');

CREATE OR REPLACE  FUNCTION droitsutilB (character varying,character varying,character varying) RETURNS text as 
$$
begin
RETURN has_database_privilege($1, $2, $3);
end
$$ language plpgsql;

SELECT droitsutilB('postgres','jeros_jardiner','CREATE');

OU

create function droitsutilBB1(character varying, character varying,character varying) returns table (matable Boolean) as
$$
Begin
Return query select  has_database_privilege($1, $2, $3);
end;
$$ language plpgsql;

Select droitsutilBB1(‘postgres’,’connect’);

----------------------------------------------------------------------------------------------------------------------------------------------
/*si l’utilisateur dont le nom est passé en 1ier paramètre a le droit donné en 2ièmeparamètre sur la BDD dont le nom est donné en 3ième paramètre.   */

SELECT has_schema_privilege('postgres','code','CREATE');

CREATE OR REPLACE  FUNCTION droitsutilS (character varying,character varying,character varying) RETURNS text as 
$$
begin
RETURN has_schema_privilege($1, $2, $3);
end
$$ language plpgsql;

SELECT droitsutilS('postgres','code','CREATE');

OU

create function droitsutilS(character varying, character varying, character varying) returns table (matable Boolean)as
$$
Begin
Return query select  has_schema_privilege($1,$2,$3);
end;
$$language plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------------
/*  adresse l’utilisateur s’est connecté   */
CREATE OR REPLACE FUNCTION commentA () RETURNS text as 
$$
begin
RETURN inet_client_addr();
end
$$ language plpgsql;

select commentA();

OU

create function commentA1()returns table (matable inet)	as
$$
Begin
Return query select inet_client_addr();
end;
$$language plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------------
/*  port l’utilisateur s’est connecté   */
CREATE FUNCTION commentP () RETURNS text as 
$$
begin
RETURN inet_server_port();
end
$$ language plpgsql;
select commentP();

ou

create function commentP() returns table (matable int)	as
$$
Begin
Return query select inet_client_port();
end;
$$ language plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------------
/*  le nom de l’utilisateur grâce à son numéro.   */
CREATE FUNCTION quiestnum (oid) RETURNS text as 
$$
begin
RETURN pg_get_userbyid($1);
end
$$ language plpgsql;

select quiestnum (10);

ou

create function quiestnum1(oid) returns table (matable name)	as
$$
Begin
Return query  select pg_get_userbyid($1);
end;
$$ language plpgsql;
Select quiestnum1(10);

----------------------------------------------------------------------------------------------------------------------------------------------
/*  la taille utilisée par une BDD.   */

SELECT pg_database_size('jeros_jardiner');

CREATE OR REPLACE FUNCTION tailleBDD (name) RETURNS text as 
$$
begin
RETURN pg_database_size($1);
end
$$ language plpgsql;

select tailleBDD('postgres');

OU

create or replace function tailleBDD1(name) returns table (matable bigint)	as
$$
Begin
Return query  select pg_database_size($1);
end ;
$$ language plpgsql;

Select tailleBDD1('postgres')

----------------------------------------------------------------------------------------------------------------------------------------------
/*  la taille utilisée par une table.   */

SELECT pg_relation_size('famille');

CREATE OR REPLACE FUNCTION tailletable (in character varying) RETURNS text as 
$$
begin
return pg_relation_size($1); 
end
$$ language plpgsql;

select tailletable ('famille');

OU

create function tailletable1(text) returns table (matable bigint)	as
$$
Begin
Return query select pg_relation_size($1);
end;
$$ language plpgsql;

Select tailletable1('famille');

----------------------------------------------------------------------------------------------------------------------------------------------
/* 12.	Améliorer les 2 dernières procédures pour avoir le résultat en octet   */

/*  la taille utilisée par une BDD en octet   */
DROP FUNCTION taillebdd(character varying);

create function tailletableB(text) returns table (matable text)	as
$$
Begin
Return query select pg_size_pretty(pg_relation_size($1));
end;
$$ language plpgsql;

select tailletableB('famille');

Ou

create function tailletableB(text) returns text	as
$$
Begin
select pg_size_pretty(pg_relation_size($1));
end;
$$ language plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------------
/*  la taille utilisée par une table on octet  */

select pg_database_size('jeros_jardiner');

CREATE FUNCTION tailletable (character varying) RETURNS text as 
$$
begin
EXECUTE 'SELECT pg_relation_size'||$1;
 
end
$$ language plpgsql;

select tailletable ();

----------------------------------------------------------------------------------------------------------------------------------------------
/*  3 procédures permettant d’utiliser les 3 dernières fonctions de l’annexe  */

CREATE OR REPLACE FUNCTION repertoire (character varying) RETURNS text as 
$$
begin
EXECUTE 'SELECT pg_ls_dir'||$1;
end
$$ language plpgsql;

SELECT pg_ls_dir('.');

OU

create function inforep(character varying) returns table(toto text)	as
$$
Begin
Return query select * from pg_ls_dir($1);
end;
$$language plpgsql;

Select * from inforep(‘.’)

create or replace function lirefichier(character varying,integer,integer) returns text	as
$$
Begin
Return pg_read_file( $1 ,$2, $3);
end
$$ language plpgsql;

Select * from lirefichier('postgresql.conf',8,8);

OU

create or replace function lirefichier1(character varying,integer,integer) returns table(nomT name)	as
$$
Begin
RETURN QUERY SELECT pg_read_file( $1 ,$2, $3);
end
$$ language plpgsql;

Select lirefichier1('postgresql.conf',8,8);


create function infofichier(character varying) returns record as
$$
Begin
Return pg_stat_file($1);
end
$$ language plpgsql;

Select infofichier('postgresql.conf');

----------------------------------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION toto() returns varchar  AS $$
declare 

    curs refcursor;
BEGIN
    open curs for select nom_fichier, to_char(date_mel,'dd/mm/yyyy') as date_mel,  nom_internaute, prenom_internaute
    from t_image
    inner join t_internaute on t_image.num_internaute=t_internaute.num_internaute;
    res:='<table border="3">';
    res:=res'<tr><td>Fichier</td><td>Date</td>;
    fetch curs into l;
    while (found) loop
        res:=res'<tr><td>'l.nom_fichier'</td><td>'l.date_mel'</td><td>'l.nom_internaute' 'l.prenom_internaute'</td></tr>';
        fetch curs into l;
    end loop;
    res:=res||'</table>';
    return res;
END;
$$ language plpgsql;
