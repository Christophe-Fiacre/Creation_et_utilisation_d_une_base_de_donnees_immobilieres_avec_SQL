-- Requête 1 : Nombre total d’appartements vendus au 1er semestre 2020.

select
	count(v.Id_vente) as Nombre_de_ventes,
    b.Type_local as Type_de_bien
from
	Vente v 
    join Bien b using (Id_bien)
where
	b.Type_local = 'Appartement'
and	v.Date between '2020-01-01' and '2020-06-30'
;


-- Requête 2 : Nombre de ventes d’appartement par région pour le 1er semestre 2020.

select
	count(v.Id_vente) as Nombre_de_ventes,
    r.Nom_region,
    b.Type_local as Type_de_bien
from
	Vente v 
    join Bien b using (Id_bien)
    join Commune c using (Id_commune)
    join Region r using (Code_region)
where
	b.Type_local = 'Appartement'
and	v.Date between '2020-01-01' and '2020-06-30'
group by 
	Nom_region
order by
	Nombre_de_ventes desc
;


-- Requête 3 : Proportion des ventes d’appartements par le nombre de pièces.

select
	b.Total_piece as Nombre_de_pieces,
	count(v.Id_vente) as Nombre_vente_appartement,
    round(count(v.Id_vente) * 100 / (select count(*) from Vente v join Bien b using (Id_bien) where b.type_local = 'Appartement'), 2) as Proportion_ventes_pour_cent
from
    Vente v 
    join Bien b using (Id_bien)
where
	b.type_local = 'Appartement'
group by
	b.Total_piece
order by
	b.Total_piece
;
    

-- Requête 4 : Liste des 10 départements où le prix du mètre carré est le plus élevé. (avec Surface_local, rank <= 10)

select
	*
from (
	select
		rank() over (order by (avg((v.valeur) / (b.surface_local))) desc) as Classement,
		d.nom_departement as Nom_departement,
		c.code_departement as Code_departement,
		round(avg((v.valeur) / (b.surface_local)),2) as Prix_au_m²
	from
		vente v
		join bien b using (Id_bien)
		join commune c using (Id_commune)
		join departement d using (Code_departement)
	group by
		nom_departement
	order by
		Prix_au_m² desc
) as liste
where Classement <= 10
;

-- Requête 4 : Liste des 10 départements où le prix du mètre carré est le plus élevé. (avec Surface_carrez, rank <= 10)

select
	*
from (
	select
		rank() over (order by (avg((v.valeur) / (b.surface_carrez))) desc) as Classement,
		d.nom_departement as Nom_departement,
		c.code_departement as Code_departement,
		round(avg((v.valeur) / (b.surface_carrez)),2) as Prix_au_m²
	from
		vente v
		join bien b using (Id_bien)
		join commune c using (Id_commune)
		join departement d using (Code_departement)
	group by
		nom_departement
	order by
		Prix_au_m² desc
) as liste
where Classement <= 10
;


-- Requête 4 : Liste des 10 départements où le prix du mètre carré est le plus élevé. (avec Surface_local, limit 10)

select
   	rank() over (order by (avg((v.valeur) / (b.surface_local))) desc) as Classement,
    d.nom_departement as Nom_departement,
    c.code_departement as Code_departement,
    round(avg((v.valeur) / (b.surface_local)),2) as Prix_au_m²
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join departement d using (Code_departement)
group by
	nom_departement
order by
	Prix_au_m² desc
limit
	10
;


-- Requête 4 : Liste des 10 départements où le prix du mètre carré est le plus élevé. (avec Surface_carrez, limit 10)

select
   	rank() over (order by (avg((v.valeur) / (b.surface_carrez))) desc) as Classement,
    d.nom_departement as Nom_departement,
    c.code_departement as Code_departement,
    round(avg((v.valeur) / (b.surface_carrez)),2) as Prix_au_m²
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join departement d using (Code_departement)
group by
	nom_departement
order by
	Prix_au_m² desc
limit
	10
;


-- Requête 5 : Prix moyen du mètre carré d’une maison en Île-de-France. (avec surface_local)

select
	round(avg((v.valeur) / (b.surface_local)),2) as Prix_moyen_au_m²,
    b.Type_local as Type_de_bien,
    r.Nom_region
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join region r using (Code_region)
where
	r.code_region = 11
and	b.type_local = 'Maison'
;


-- Requête 5 : Prix moyen du mètre carré d’une maison en Île-de-France. (avec surface_carrez)

select
	round(avg((v.valeur) / (b.surface_carrez)),2) as Prix_moyen_au_m²,
    b.Type_local as Type_de_bien,
    r.Nom_region
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join region r using (Code_region)
where
	r.code_region = 11
and	b.type_local = 'Maison'
;


-- Requête 6 : Liste des 10 appartements les plus chers avec la région et le nombre de mètres carrés. (avec surface_local, rank <= 10)

select
	*
from (
	select
		rank() over(order by v.valeur desc) as classement,
		b.id_bien as identifiant_du_bien,
		v.valeur,
		r.nom_region,
		r.code_region,
		b.surface_local
	from
		vente v
		join bien b using (Id_bien)
		join commune c using (Id_commune)
		join region r using (Code_region)
	where
		b.type_local = 'Appartement'
	group by
		v.valeur
	order by
		v.valeur desc
) as liste
where
	classement <= 10
;


-- Requête 6 : Liste des 10 appartements les plus chers avec la région et le nombre de mètres carrés. (avec surface_local, limit 10)

select
	rank() over(order by v.valeur desc) as classement,
    b.id_bien as identifiant_du_bien,
	v.valeur,
    r.nom_region,
    r.code_region,
    b.surface_local
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join region r using (Code_region)
where
	b.type_local = 'Appartement'
group by
	v.valeur
order by
	v.valeur desc
limit
	10
;


-- Requête 6 : Liste des 10 appartements les plus chers avec la région et le nombre de mètres carrés. (avec surface_carrez, rank <= 10)

select
	*
from (
	select
		rank() over(order by v.valeur desc) as classement,
		b.id_bien as identifiant_du_bien,
		v.valeur,
		r.nom_region,
        c.Code_departement,
		b.surface_carrez
	from
		vente v
		join bien b using (Id_bien)
		join commune c using (Id_commune)
		join region r using (Code_region)
	where
		b.type_local = 'Appartement'
	group by
		v.valeur
	order by
		v.valeur desc
) as liste
where
	classement <= 10
;


-- Requête 6 : Liste des 10 appartements les plus chers avec la région et le nombre de mètres carrés. (avec surface_carrez, limit 10)

select
	rank() over(order by v.valeur desc) as classement,
    b.id_bien as identifiant_du_bien,
	v.valeur,
    r.nom_region,
	c.Code_departement,
    b.surface_carrez
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join region r using (Code_region)
where
	b.type_local = 'Appartement'
group by
	v.valeur
order by
	v.valeur desc
limit
	10
;


-- Requête 7 : Taux d’évolution du nombre de ventes entre le premier et le second trimestre de 2020.

with vtrim1 as (
	select 
		count(v.id_vente) as nbre_vente_trimestre1
	from 
		vente v 
    where 
		v.date between '2020-01-01' and '2020-03-31'),
vtrim2 as (
	select 
		count(v.id_vente) as nbre_vente_trimestre2
	from 
		vente v 
	where 
		v.date between '2020-04-01' and '2020-06-30'),
vtotal as (
	select 
		count(*) as nbre_vente_total
	from 
		vente v)
select
	round((nbre_vente_trimestre1 * 100) / nbre_vente_total, 2) as Taux_nombre_de_ventes_1er_trimestre,
    round((nbre_vente_trimestre2 * 100) / nbre_vente_total, 2) as Taux_nombre_de_ventes_2nd_trimestre,
    round(((((nbre_vente_trimestre2 * 100) / nbre_vente_total) - ((nbre_vente_trimestre1 * 100) / nbre_vente_total)) / ((nbre_vente_trimestre1 * 100) / nbre_vente_total)) * 100, 2) as Taux_evolution
from
	vtrim1,
    vtrim2,
    vtotal
;


-- Requête 8 : Le classement des régions par rapport au prix au mètre carré des appartement de plus de 4 pièces. (avec surface_local)

select
	rank() over(order by round(avg((v.valeur) / (b.surface_local)),2) desc) as Classement,
    r.Nom_region,
	round(avg((v.valeur) / (b.surface_local)),2) as Prix_au_m²,
    b.Type_local as Type_de_bien,
    b.Total_piece
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join region r using (Code_region)
where
	b.type_local = 'Appartement'
and	b.total_piece > 4
group by
	r.nom_region
order by
	Prix_au_m² desc
;


-- Requête 8 : Le classement des régions par rapport au prix au mètre carré des appartement de plus de 4 pièces. (avec surface_carrez)

select
	rank() over(order by round(avg((v.valeur) / (b.surface_carrez)),2) desc) as Classement,
    r.Nom_region,
	round(avg((v.valeur) / (b.surface_carrez)),2) as Prix_au_m²,
    b.Type_local as Type_de_bien,
    b.Total_piece
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join region r using (Code_region)
where
	b.type_local = 'Appartement'
and	b.total_piece > 4
group by
	r.nom_region
order by
	Prix_au_m² desc
;


-- Requête 9 : Liste des communes ayant eu au moins 50 ventes au 1er trimestre.

select
	c.Nom_commune,
    count(v.id_vente) as Nombre_de_ventes
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
where
	v.date between '2020-01-01' and '2020-03-31'
group by
	c.nom_commune
having
	count(v.id_vente) >= 50
order by
	nom_commune
;


-- Requête 10 : Différence en pourcentage du prix au mètre carré entre un appartement de 2 pièces et un appartement de 3 pièces. (avec surface_local)

with Prix_m²_apptmt_2p as (
	select
		round(avg((v.valeur) / (b.surface_local)),2) as Prix_au_m²_appartement_2_pieces
	from
		vente v
		join bien b using (Id_bien)
	where
		b.type_local = 'Appartement'
	and	b.total_piece = 2),
Prix_m²_apptmt_3p as (
	select
		round(avg((v.valeur) / (b.surface_local)),2) as Prix_au_m²_appartement_3_pieces
	from
		vente v
		join bien b using (Id_bien)
	where
		b.type_local = 'Appartement'
	and	b.total_piece = 3)
select
	Prix_au_m²_appartement_2_pieces,
    Prix_au_m²_appartement_3_pieces,
    round(Prix_au_m²_appartement_2_pieces - Prix_au_m²_appartement_3_pieces, 2) as Difference_prix_au_m²_appartement_2p_et_3p,
    round(-(((Prix_au_m²_appartement_2_pieces - Prix_au_m²_appartement_3_pieces) * 100) / Prix_au_m²_appartement_2_pieces), 2) as Difference_en_pourcent_prix_au_m²_appartement_2p_et_3p
from
	Prix_m²_apptmt_2p,
    Prix_m²_apptmt_3p
;


-- Requête 10 : Différence en pourcentage du prix au mètre carré entre un appartement de 2 pièces et un appartement de 3 pièces. (avec surface_carrez)

with Prix_m²_apptmt_2p as (
	select
		round(avg((v.valeur) / (b.surface_carrez)), 2) as Prix_au_m²_appartement_2_pieces
	from
		vente v
		join bien b using (Id_bien)
	where
		b.type_local = 'Appartement'
	and	b.total_piece = 2),
Prix_m²_apptmt_3p as (
	select
		round(avg((v.valeur) / (b.surface_carrez)),2) as Prix_au_m²_appartement_3_pieces
	from
		vente v
		join bien b using (Id_bien)
	where
		b.type_local = 'Appartement'
	and	b.total_piece = 3)
select
	Prix_au_m²_appartement_2_pieces,
    Prix_au_m²_appartement_3_pieces,
    round(Prix_au_m²_appartement_2_pieces - Prix_au_m²_appartement_3_pieces, 2) as Difference_prix_au_m²_appartement_2p_et_3p,
    round(-(((Prix_au_m²_appartement_2_pieces - Prix_au_m²_appartement_3_pieces) * 100) / Prix_au_m²_appartement_2_pieces), 2) as Difference_en_pourcent_prix_au_m²_appartement_2p_et_3p
from
	Prix_m²_apptmt_2p,
    Prix_m²_apptmt_3p
;


-- Requête 11 : Les moyennes de valeurs foncières pour le top 3 des communes des départements 6, 13, 33, 59 et 69.

with dep6 as (
select
	rank() over(order by avg(v.valeur) desc) as Classement,
	round(avg(v.valeur),2) as Moyenne_valeurs_foncieres,
	c.Nom_commune,
	d.Nom_departement,
    d.code_departement
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join departement d using (Code_departement)
where
	d.code_departement = 6
group by
	c.nom_commune
limit
	3),
dep13 as (
select
	rank() over(order by avg(v.valeur) desc) as Classement,
	round(avg(v.valeur),2) as Moyenne_valeurs_foncieres,
	c.Nom_commune,
	d.Nom_departement,
    d.code_departement
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join departement d using (Code_departement)
where
	d.code_departement = 13
group by
	c.nom_commune
limit
	3),
dep33 as (
select
	rank() over(order by avg(v.valeur) desc) as Classement,
	round(avg(v.valeur),2) as Moyenne_valeurs_foncieres,
	c.Nom_commune,
	d.Nom_departement,
    d.code_departement
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join departement d using (Code_departement)
where
	d.code_departement = 33
group by
	c.nom_commune
limit
	3),
dep59 as (
select
	rank() over(order by avg(v.valeur) desc) as Classement,
	round(avg(v.valeur),2) as Moyenne_valeurs_foncieres,
	c.Nom_commune,
	d.Nom_departement,
    d.code_departement
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join departement d using (Code_departement)
where
	d.code_departement = 59
group by
	c.nom_commune
limit
	3),
dep69 as (
select
	rank() over(order by avg(v.valeur) desc) as Classement,
	round(avg(v.valeur),2) as Moyenne_valeurs_foncieres,
	c.Nom_commune,
	d.Nom_departement,
    d.code_departement
from
	vente v
    join bien b using (Id_bien)
    join commune c using (Id_commune)
    join departement d using (Code_departement)
where
	d.code_departement = 69
group by
	c.nom_commune
limit
	3)
select * from dep6
union all
select * from dep13
union all
select * from dep33
union all
select * from dep59
union all
select * from dep69
;

