xquery version "3.1";

(:
  ============================================================

  Consultas XPath — Navegación básica sobre employees y jobs
  Colección: /data/oscar_lozano.xml

:)

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare variable $doc := doc("/data/oscar_lozano.xml");


(: ============================================================
   EMPLOYEES — Navegación básica
   ============================================================ :)

(: XP-E1 — Todos los nodos employee completos :)
$doc//employees/employee


(: ============================================================
   XP-E2 — Solo el primer empleado (por posición)
   ============================================================ :)
(:
$doc//employees/employee[1]
:)


(: ============================================================
   XP-E3 — Último empleado
   ============================================================ :)
(:
$doc//employees/employee[last()]
:)


(: ============================================================
   XP-E4 — Solo los apellidos de todos los empleados
   ============================================================ :)
(:
$doc//employees/employee/last_name
:)


(: ============================================================
   XP-E5 — Nombre completo: acceder a dos hijos del mismo nodo
   ============================================================ :)
(:
$doc//employees/employee/(first_name | last_name)
:)


(: ============================================================
   XP-E6 — Todos los hijos directos del primer employee
   ============================================================ :)
(:
$doc//employees/employee[1]/child::*
:)


(: ============================================================
   XP-E7 — email de todos los empleados (texto plano, sin etiquetas)
   ============================================================ :)
(:
$doc//employees/employee/email/text()
:)


(: ============================================================
   XP-E8 — hire_date de todos los empleados
   ============================================================ :)
(:
$doc//employees/employee/hire_date
:)


(: ============================================================
   XP-E9 — salary de todos los empleados
   ============================================================ :)
(:
$doc//employees/employee/salary
:)


(: ============================================================
   XP-E10 — department_id de cada empleado (navegar hacia arriba
             con parent:: para confirmar el contexto)
   ============================================================ :)
(:
$doc//employees/employee/department_id/parent::employee/last_name
:)


(: ============================================================
   XP-E11 — manager_id solo cuando NO está vacío (predicado simple)
   ============================================================ :)
(:
$doc//employees/employee[manager_id != ""]/manager_id
:)




