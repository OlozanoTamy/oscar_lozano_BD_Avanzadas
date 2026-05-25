xquery version "3.1";



declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "xml";
declare option output:indent "yes";

(: ── Ruta base del documento ── :)
declare variable $doc := doc("/data/oscar_lozano.xml");


(: ============================================================
   Q1 — Listar todos los empleados
   Retorna nombre completo y salario de cada empleado.
   ============================================================ :)
<resultado query="Q1" descripcion="Todos los empleados">
{
  for $e in $doc//employees/employee
  return
    <empleado id="{ $e/employee_id }">
      <nombre>{ concat($e/first_name, " ", $e/last_name) }</nombre>
      <salario>{ $e/salary/text() }</salario>
    </empleado>
}
</resultado>


(: ============================================================
   Q2 — Empleados con salario mayor a $10,000
   Filtra y ordena de mayor a menor salario.
   ============================================================ :)
(:
<resultado query="Q2" descripcion="Salario mayor a 10000">
{
  for $e in $doc//employees/employee
  where xs:decimal($e/salary) > 10000
  order by xs:decimal($e/salary) descending
  return
    <empleado salario="{ $e/salary/text() }">
      { concat($e/first_name, " ", $e/last_name) }
    </empleado>
}
</resultado>
:)


(: ============================================================
   Q3 — Empleado con su departamento (join)
   Une employees con departments por department_id.
   ============================================================ :)
(:
<resultado query="Q3" descripcion="Empleados con departamento">
{
  for $e in $doc//employees/employee
  let $dept := $doc//departments/department[department_id = $e/department_id]
  return
    <registro>
      <empleado>{ concat($e/first_name, " ", $e/last_name) }</empleado>
      <departamento>{ $dept/department_name/text() }</departamento>
    </registro>
}
</resultado>
:)


(: ============================================================
   Q4 — Salario promedio por departamento (agregación)
   Solo incluye departamentos con al menos un empleado.
   ============================================================ :)
(:
<resultado query="Q4" descripcion="Promedio salarial por departamento">
{
  for $dept in $doc//departments/department
  let $empleados := $doc//employees/employee[department_id = $dept/department_id]
  let $promedio  := avg($empleados/salary/xs:decimal(.))
  where count($empleados) > 0
  return
    <dept nombre="{ $dept/department_name }"
          empleados="{ count($empleados) }"
          promedio="{ format-number($promedio, '#,##0.00') }"/>
}
</resultado>
:)


(: ============================================================
   Q5 — Empleados contratados después de 1993
   Compara fechas usando xs:date para tipado correcto.
   ============================================================ :)
(:
<resultado query="Q5" descripcion="Contratados después del 31-dic-1993">
{
  for $e in $doc//employees/employee
  where xs:date($e/hire_date) > xs:date("1993-12-31")
  order by xs:date($e/hire_date)
  return
    <contratado fecha="{ $e/hire_date }">
      { concat($e/first_name, " ", $e/last_name) }
    </contratado>
}
</resultado>
:)


(: ============================================================
   Q6 — Historial laboral con nombre de cargo (join triple)
   Cruza job_history + employees + jobs.
   ============================================================ :)
(:
<resultado query="Q6" descripcion="Historial laboral con cargo">
{
  for $h in $doc//job_history/job_record
  let $job := $doc//jobs/job[job_id = $h/job_id]
  let $emp := $doc//employees/employee[employee_id = $h/employee_id]
  return
    <historial>
      <empleado>{ concat($emp/first_name, " ", $emp/last_name) }</empleado>
      <cargo>{ $job/job_title/text() }</cargo>
      <inicio>{ $h/start_date/text() }</inicio>
      <fin>{ $h/end_date/text() }</fin>
    </historial>
}
</resultado>
:)


(: ============================================================
   Q7 — Conteo de empleados por país (join en cadena)
   Recorre: employees → departments → locations → countries.
   ============================================================ :)
(:
<resultado query="Q7" descripcion="Empleados por país">
{
  for $c in $doc//countries/country
  let $locs  := $doc//locations/location[country_id = $c/country_id]
  let $depts := $doc//departments/department[location_id = $locs/location_id]
  let $emps  := $doc//employees/employee[department_id = $depts/department_id]
  where count($emps) > 0
  return
    <pais nombre="{ $c/country_name }"
          empleados="{ count($emps) }"/>
}
</resultado>
:)


(: ============================================================
   Q8 — Rango salarial por cargo
   Muestra min, max y la brecha de cada puesto.
   ============================================================ :)
(:
<resultado query="Q8" descripcion="Rango salarial por cargo">
{
  for $j in $doc//jobs/job
  let $min := xs:decimal($j/min_salary)
  let $max := xs:decimal($j/max_salary)
  order by $max descending
  return
    <cargo titulo="{ $j/job_title }"
           min="{ $min }"
           max="{ $max }"
           brecha="{ $max - $min }"/>
}
</resultado>
:)


(: ============================================================
   Q9 — Buscar empleado por apellido (búsqueda de texto)
   Modifica $busqueda para filtrar por apellido parcial.
   ============================================================ :)
(:
declare variable $busqueda as xs:string := "king";

<resultado query="Q9" descripcion="Búsqueda por apellido: '{ $busqueda }'">
{
  for $e in $doc//employees/employee
  where contains(lower-case($e/last_name), lower-case($busqueda))
  return $e
}
</resultado>
:)


(: ============================================================
   Q10 — Top 3 empleados mejor pagados (paginación)
   Usa subsequence(secuencia, inicio, longitud).
   ============================================================ :)
(:
<resultado query="Q10" descripcion="Top 3 salarios">
{
  let $ordenados :=
    for $e in $doc//employees/employee
    where $e/salary != ""
    order by xs:decimal($e/salary) descending
    return $e
  for $top at $pos in subsequence($ordenados, 1, 3)
  return
    <top posicion="{ $pos }"
         nombre="{ concat($top/first_name, " ", $top/last_name) }"
         salario="{ $top/salary }"/>
}
</resultado>
:)

