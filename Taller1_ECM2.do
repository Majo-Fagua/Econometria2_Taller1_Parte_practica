/* - * - * - * - * - * - * - * - * - * - * - * - * - * - * - * - * - * - * - * - 
*																			   *
*						     Taller 1 Econometría 2						       *
*								Parte práctica								   *
* - * - * - * - * - * - * - * - *  - * - * - * - * - * - * - * - * - * - * - * */

clear all
cap log close
set more off

cd "C:\Users\majo_\OneDrive\Escritorio\Econometría 2\Taller 1"
global dir "C:\Users\majo_\OneDrive\Escritorio\Econometría 2\Taller 1"
use "$dir\programa_afro_choco.dta" 


/*  1. Evaluación de impacto programa piloto de transferencias condicionales en 
	hogares del municipio del Chocó.											*/
	
	ssc install estout, replace
	ssc install outreg2, replace
**# (a) Análisis exploratorio: estadísiticas descriptivas

	estpost sum zona_rural_i acceso_agua_i nbi_i edad_jefe_i ///
		identidad_afro_i dist_cabecera_i tam_hogar_i sexo_jefe_i ///
		educ_jefe_i pct_pobl_afro_i D_i ingreso_i
		
	esttab using "$dir\estadisticas_descriptivas.rtf", ///
    cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))") ///
    collabels("N" "Media" "Desv. Est." "Mín." "Máx.") ///
    nonumber noobs ///
    title("Estadísticas descriptivas") ///
    replace

**# (b) Modelo simple efecto del programa sobre ingreso del hogar
*		Estimar por MCO ingreso_i = β0 + β1 D_i + ɛ_i 

	reg ingreso_i D_i
	
	outreg2 using "$dir\reg_1b.doc", replace ///
	ctitle("Efecto del programa sobre ingreso del hogar") ///
	bdec(3) sdec(3)
	
**# (c) Prueba diferencia de medias entre los tratados y el grupo de control

	local control zona_rural_i acceso_agua_i nbi_i edad_jefe_i educ_jefe_i ///
		  sexo_jefe_i  tam_hogar_i identidad_afro_i dist_cabecera_i

	label variable zona_rural_i "Zona rural"
	label variable acceso_agua_i "Acceso a agua"
	label variable nbi_i "NBI"
	label variable edad_jefe_i "Edad jefe de hogar"
	label variable educ_jefe_i "Educación jefe de hogar"
	label variable sexo_jefe_i "Sexo jefe de hogar"
	label variable tam_hogar_i "Tamaño del hogar"
	label variable identidad_afro_i "Identidad afro"
	label variable dist_cabecera_i "Distancia a cabecera"

	estpost ttest `control', by (D_i)
	esttab using "$dir\ttest.rtf", ///
	cells("mu_1(fmt(3)) mu_2(fmt(3)) b(fmt(3)) p(fmt(3))") ///
    collabels("Media tratados" "Media controles" "Diferencia" "p-valor") ///
    label nonumber noobs ///
	title("Prueba de diferencia de medias") replace
	
/*  2. Sugerencias realizadas por el supervisor.								*/
		
		
**# (a) Modelo simple efecto del programa sobre ingreso del hogar con NBI como 
*		variable de control.
*		Estimar por MCO ingreso_i = β0 + β1 D_i + β2 nbi_i + ɛ_i 				*/

	reg ingreso_i D_i nbi_i
	
	outreg2 using "$dir\reg_2a.doc", replace ///
	ctitle("Efecto del programa sobre ingreso del hogar, controlado por NBI") ///
	bdec(3) sdec(3) 

**# (b) Explorar si el efecto del programa sobre el ingreso difiere entre 
*		hogares con y sin acceso a agua potable, controlando por nbi.
*		Estimar por MCO 
*		ingreso_i = β0 + β1D_i + β2acceso_agua_i + β3acceso_agua_ixD_i + β4nbi_i + ɛ_i  */

	reg ingreso_i i.acceso_agua_i##i.D_i nbi_i
	
	outreg2 using "$dir\reg_2b.doc", replace ///
	ctitle("Efecto del programa sobre ingreso del hogar, controlado por NBI y según acceso a agua potable") ///
	bdec(3) sdec(3)
		

