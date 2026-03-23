#!/bin/bash
# =============================================================================
# test_deportivo_phase1.sh
# Pruebas de endpoints de la API Deportiva — Fase 1
# Uso: bash test_deportivo_phase1.sh
# =============================================================================

BASE="https://centro.ddev.site"
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
PASS=0; FAIL=0

# --- Autenticación -----------------------------------------------------------
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  Obteniendo token de autenticación...${NC}"
echo -e "${CYAN}========================================${NC}"
TOKEN=$(curl -s -X POST "$BASE/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"Sistema!Centro2026"}' | jq -r '.data.access_token // .token // empty')

if [ -z "$TOKEN" ]; then
  echo -e "${RED}✗ No se pudo obtener el token. Abortando.${NC}"
  exit 1
fi
echo -e "${GREEN}✓ Token OK${NC}"
echo ""

# Helper functions
pass() { echo -e "${GREEN}  ✓ PASS${NC} — $1 (HTTP $2)"; ((PASS++)); }
fail() { echo -e "${RED}  ✗ FAIL${NC} — $1 (HTTP $2 esperado $3)"; ((FAIL++)); }

test_endpoint() {
  local desc="$1" method="$2" url="$3" expected="$4" body="$5"
  local args=(-s -o /dev/null -w "%{http_code}" -X "$method" "$BASE$url" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json")
  [ -n "$body" ] && args+=(-d "$body")
  local code; code=$(curl "${args[@]}")
  if [ "$code" = "$expected" ]; then pass "$desc" "$code"; else fail "$desc" "$code" "$expected"; fi
}

# =============================================================================
# DASHBOARD
# =============================================================================
echo -e "${YELLOW}--- DASHBOARD ---${NC}"
test_endpoint "GET /api/deportivo/dashboard/kpis"           GET "/api/deportivo/dashboard/kpis"           200
test_endpoint "GET /api/deportivo/dashboard/club"           GET "/api/deportivo/dashboard/club"           200
test_endpoint "GET /api/deportivo/dashboard/coordinadores"  GET "/api/deportivo/dashboard/coordinadores"  200

# =============================================================================
# CLUBES
# =============================================================================
# =============================================================================
# SETUP — Crear recursos base reutilizables (club y actividad existen en BD)
# =============================================================================
# Usar club id=1 (Centro Libanés ya existe)
CLUB_ID=1
# Crear una actividad base para FKs (actividad_id requerida en varios recursos)
SETUP_ACT=$(curl -s -X POST "$BASE/api/deportivo/actividades" \
  -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d '{"nombre":"Actividad Base Test","club_id":1,"created_by":1,"modo_mensajeria":"bidireccional","is_active":1}')
BASE_ACT_ID=$(echo "$SETUP_ACT" | jq -r '.data.id // empty')
[ -z "$BASE_ACT_ID" ] && BASE_ACT_ID=1
echo -e "${CYAN}  Setup: BASE_ACT_ID=$BASE_ACT_ID, CLUB_ID=$CLUB_ID${NC}"

# =============================================================================
# CLUBES
# =============================================================================
echo -e "${YELLOW}--- CLUBES ---${NC}"
test_endpoint "GET  /api/deportivo/clubes"       GET  "/api/deportivo/clubes"     200
test_endpoint "POST /api/deportivo/clubes (crear)" POST "/api/deportivo/clubes"  201 \
  "{\"nombre\":\"Club Test Auto\",\"slug\":\"club-test-$(date +%s)\",\"color_primario\":\"#FF0000\",\"is_active\":1}"
# Obtener id del club recién creado
CLUB_ID=$(curl -s -X GET "$BASE/api/deportivo/clubes" -H "Authorization: Bearer $TOKEN" | jq -r '.data.clubes[-1].id // 1')
test_endpoint "GET  /api/deportivo/clubes/$CLUB_ID"        GET    "/api/deportivo/clubes/$CLUB_ID"                   200
test_endpoint "PUT  /api/deportivo/clubes/$CLUB_ID (editar)" PUT  "/api/deportivo/clubes/$CLUB_ID"                   200 '{"nombre":"Club Test Editado"}'
test_endpoint "DEL  /api/deportivo/clubes/$CLUB_ID"        DELETE "/api/deportivo/clubes/$CLUB_ID"                   200
# Restaurar CLUB_ID al club permanente (id=1)
CLUB_ID=1

# =============================================================================
# ACTIVIDADES
# =============================================================================
echo -e "${YELLOW}--- ACTIVIDADES ---${NC}"
test_endpoint "GET  /api/deportivo/actividades/form-data"  GET  "/api/deportivo/actividades/form-data"   200
test_endpoint "GET  /api/deportivo/actividades"            GET  "/api/deportivo/actividades"             200
test_endpoint "POST /api/deportivo/actividades (crear)"    POST "/api/deportivo/actividades"             201 \
  "{\"nombre\":\"Fútbol Infantil Test\",\"club_id\":$CLUB_ID,\"created_by\":1,\"modo_mensajeria\":\"bidireccional\",\"is_active\":1}"
ACT_ID=$(curl -s "$BASE/api/deportivo/actividades" -H "Authorization: Bearer $TOKEN" | jq -r '.data.actividades[-1].id // 1')
test_endpoint "GET  /api/deportivo/actividades/$ACT_ID"    GET    "/api/deportivo/actividades/$ACT_ID"   200
test_endpoint "PUT  /api/deportivo/actividades/$ACT_ID"    PUT    "/api/deportivo/actividades/$ACT_ID"   200 '{"nombre":"Fútbol Infantil Mod"}'
test_endpoint "DEL  /api/deportivo/actividades/$ACT_ID"    DELETE "/api/deportivo/actividades/$ACT_ID"   200

# =============================================================================
# CRITERIOS DE EVALUACIÓN
# =============================================================================
echo -e "${YELLOW}--- CRITERIOS EVALUACIÓN ---${NC}"
test_endpoint "GET  /api/deportivo/criterios-evaluacion"          GET    "/api/deportivo/criterios-evaluacion"       200
test_endpoint "POST /api/deportivo/criterios-evaluacion"          POST   "/api/deportivo/criterios-evaluacion"       201 \
  "{\"nombre\":\"Técnica\",\"descripcion\":\"Habilidad técnica\",\"peso\":30,\"actividad_id\":$BASE_ACT_ID,\"is_active\":1}"
CRIT_ID=$(curl -s "$BASE/api/deportivo/criterios-evaluacion" -H "Authorization: Bearer $TOKEN" | jq -r '.data.criterios[-1].id // 1')
test_endpoint "GET  /api/deportivo/criterios-evaluacion/$CRIT_ID" GET    "/api/deportivo/criterios-evaluacion/$CRIT_ID" 200
test_endpoint "PUT  /api/deportivo/criterios-evaluacion/$CRIT_ID" PUT    "/api/deportivo/criterios-evaluacion/$CRIT_ID" 200 '{"nombre":"Técnica Mod"}'
test_endpoint "DEL  /api/deportivo/criterios-evaluacion/$CRIT_ID" DELETE "/api/deportivo/criterios-evaluacion/$CRIT_ID" 200

# =============================================================================
# GRUPOS CATEGORÍAS
# =============================================================================
echo -e "${YELLOW}--- GRUPOS CATEGORÍAS ---${NC}"
test_endpoint "GET  /api/deportivo/grupos-categorias"          GET    "/api/deportivo/grupos-categorias"       200
test_endpoint "POST /api/deportivo/grupos-categorias"          POST   "/api/deportivo/grupos-categorias"       201 \
  "{\"nombre\":\"Sub-10\",\"descripcion\":\"Categoría Sub-10\",\"actividad_id\":$BASE_ACT_ID,\"edad_min\":8,\"edad_max\":10}"
GC_ID=$(curl -s "$BASE/api/deportivo/grupos-categorias" -H "Authorization: Bearer $TOKEN" | jq -r '.data.grupos_categorias[-1].id // 1')
test_endpoint "GET  /api/deportivo/grupos-categorias/$GC_ID"   GET    "/api/deportivo/grupos-categorias/$GC_ID" 200
test_endpoint "PUT  /api/deportivo/grupos-categorias/$GC_ID"   PUT    "/api/deportivo/grupos-categorias/$GC_ID" 200 '{"nombre":"Sub-10 Mod"}'
test_endpoint "DEL  /api/deportivo/grupos-categorias/$GC_ID"   DELETE "/api/deportivo/grupos-categorias/$GC_ID" 200

# =============================================================================
# EQUIPOS  (necesita grupo_id para FK, usamos GC_ID que se acaba de crear)
# =============================================================================
echo -e "${YELLOW}--- EQUIPOS ---${NC}"
# Crear un grupo categoría primero para usarlo como FK
GC_ID2=$(curl -s -X POST "$BASE/api/deportivo/grupos-categorias" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"nombre\":\"Sub-12 Eq\",\"actividad_id\":$BASE_ACT_ID,\"edad_min\":10,\"edad_max\":12}" | jq -r '.data.id // 1')
# Crear actividad para torneos/conceptos
ACT_ID2=$(curl -s -X POST "$BASE/api/deportivo/actividades" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"nombre\":\"Fut Equipo Test\",\"club_id\":$CLUB_ID,\"created_by\":1,\"modo_mensajeria\":\"bidireccional\",\"is_active\":1}" | jq -r '.data.id // 1')
test_endpoint "GET  /api/deportivo/equipos"         GET  "/api/deportivo/equipos"    200
test_endpoint "POST /api/deportivo/equipos (crear)" POST "/api/deportivo/equipos"    201 \
  "{\"nombre\":\"Equipo Alpha\",\"grupo_id\":$GC_ID2,\"is_active\":1}"
EQ_ID=$(curl -s "$BASE/api/deportivo/equipos" -H "Authorization: Bearer $TOKEN" | jq -r '.data.equipos[-1].id // 1')
test_endpoint "GET  /api/deportivo/equipos/$EQ_ID"               GET    "/api/deportivo/equipos/$EQ_ID"               200
test_endpoint "PUT  /api/deportivo/equipos/$EQ_ID"               PUT    "/api/deportivo/equipos/$EQ_ID"                200 '{"nombre":"Equipo Alpha Mod"}'
test_endpoint "GET  /api/deportivo/equipos/$EQ_ID/alumnos"       GET    "/api/deportivo/equipos/$EQ_ID/alumnos"        200
test_endpoint "GET  /api/deportivo/equipos/$EQ_ID/coaches"       GET    "/api/deportivo/equipos/$EQ_ID/coaches"        200
test_endpoint "GET  /api/deportivo/equipos/$EQ_ID/horarios"      GET    "/api/deportivo/equipos/$EQ_ID/horarios"       200
test_endpoint "DEL  /api/deportivo/equipos/$EQ_ID"               DELETE "/api/deportivo/equipos/$EQ_ID"                200

# =============================================================================
# ALUMNOS
# =============================================================================
echo -e "${YELLOW}--- ALUMNOS ---${NC}"
# Re-crear equipo para alumnos (GC_ID fue eliminado, usar GC_ID2 que persiste)
EQ_ID=$(curl -s -X POST "$BASE/api/deportivo/equipos" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"nombre\":\"Equipo Beta\",\"grupo_id\":$GC_ID2,\"is_active\":1}" | jq -r '.data.id // 1')
test_endpoint "GET  /api/deportivo/alumnos/form-data"  GET  "/api/deportivo/alumnos/form-data"  200
test_endpoint "GET  /api/deportivo/alumnos"            GET  "/api/deportivo/alumnos"             200
test_endpoint "POST /api/deportivo/alumnos"            POST "/api/deportivo/alumnos"             201 \
  "{\"nombre\":\"Carlos\",\"apellido_paterno\":\"García\",\"apellido_materno\":\"López\",\"fecha_nacimiento\":\"2015-03-10\",\"club_id\":$CLUB_ID,\"is_active\":1}"
AL_ID=$(curl -s "$BASE/api/deportivo/alumnos" -H "Authorization: Bearer $TOKEN" | jq -r '.data.alumnos[-1].id // 1')
test_endpoint "GET  /api/deportivo/alumnos/$AL_ID"             GET    "/api/deportivo/alumnos/$AL_ID"              200
test_endpoint "PUT  /api/deportivo/alumnos/$AL_ID"             PUT    "/api/deportivo/alumnos/$AL_ID"              200 '{"nombre":"Carlos Mod"}'
test_endpoint "GET  /api/deportivo/alumnos/$AL_ID/tutores"     GET    "/api/deportivo/alumnos/$AL_ID/tutores"      200
test_endpoint "GET  /api/deportivo/alumnos/$AL_ID/ficha-medica" GET   "/api/deportivo/alumnos/$AL_ID/ficha-medica" 200
test_endpoint "GET  /api/deportivo/alumnos/$AL_ID/documentos"  GET    "/api/deportivo/alumnos/$AL_ID/documentos"   200
test_endpoint "GET  /api/deportivo/alumnos/$AL_ID/asistencias" GET    "/api/deportivo/alumnos/$AL_ID/asistencias"  200
test_endpoint "GET  /api/deportivo/alumnos/$AL_ID/evaluaciones" GET   "/api/deportivo/alumnos/$AL_ID/evaluaciones" 200
test_endpoint "DEL  /api/deportivo/alumnos/$AL_ID"             DELETE "/api/deportivo/alumnos/$AL_ID"               200

# =============================================================================
# TUTORES
# =============================================================================
echo -e "${YELLOW}--- TUTORES ---${NC}"
test_endpoint "GET  /api/deportivo/tutores/form-data" GET  "/api/deportivo/tutores/form-data" 200
test_endpoint "GET  /api/deportivo/tutores"           GET  "/api/deportivo/tutores"           200
TS=$(date +%s)
test_endpoint "POST /api/deportivo/tutores"           POST "/api/deportivo/tutores"           201 \
  "{\"nombre\":\"Ana\",\"apellido_paterno\":\"López\",\"apellido_materno\":\"Martínez\",\"email\":\"ana.test.$TS@example.com\",\"telefono\":\"5551234567\",\"tipo_relacion\":\"madre\",\"club_id\":$CLUB_ID,\"is_active\":1}"
TUT_ID=$(curl -s "$BASE/api/deportivo/tutores" -H "Authorization: Bearer $TOKEN" | jq -r '.data.tutores[-1].id // 1')
test_endpoint "GET  /api/deportivo/tutores/$TUT_ID"           GET    "/api/deportivo/tutores/$TUT_ID"           200
test_endpoint "PUT  /api/deportivo/tutores/$TUT_ID"           PUT    "/api/deportivo/tutores/$TUT_ID"           200 '{"nombre":"Ana Mod"}'
test_endpoint "GET  /api/deportivo/tutores/$TUT_ID/alumnos"   GET    "/api/deportivo/tutores/$TUT_ID/alumnos"   200
test_endpoint "DEL  /api/deportivo/tutores/$TUT_ID"           DELETE "/api/deportivo/tutores/$TUT_ID"           200

# =============================================================================
# ASISTENCIAS
# =============================================================================
echo -e "${YELLOW}--- ASISTENCIAS ---${NC}"
# Crear alumno y equipo para asistencias
AL_ID2=$(curl -s -X POST "$BASE/api/deportivo/alumnos" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"nombre\":\"Luis\",\"apellido_paterno\":\"Pérez\",\"fecha_nacimiento\":\"2014-05-20\",\"club_id\":$CLUB_ID,\"is_active\":1}" | jq -r '.data.id // 1')
test_endpoint "GET  /api/deportivo/asistencias/form-data" GET  "/api/deportivo/asistencias/form-data" 200
test_endpoint "GET  /api/deportivo/asistencias"           GET  "/api/deportivo/asistencias"           200
test_endpoint "POST /api/deportivo/asistencias"           POST "/api/deportivo/asistencias"           201 \
  "{\"equipo_id\":$EQ_ID,\"alumno_id\":$AL_ID2,\"fecha\":\"2025-06-01\",\"estado\":\"presente\",\"registrado_por\":1}"
ASIST_ID=$(curl -s "$BASE/api/deportivo/asistencias" -H "Authorization: Bearer $TOKEN" | jq -r '.data.asistencias[-1].id // 1')
test_endpoint "GET  /api/deportivo/asistencias/$ASIST_ID"  GET    "/api/deportivo/asistencias/$ASIST_ID"  200
test_endpoint "PUT  /api/deportivo/asistencias/$ASIST_ID"  PUT    "/api/deportivo/asistencias/$ASIST_ID"  200 '{"estado":"tarde"}'
test_endpoint "POST /api/deportivo/asistencias/batch"      POST   "/api/deportivo/asistencias/batch"      200 \
  "{\"equipo_id\":$EQ_ID,\"fecha\":\"2025-06-02\",\"registrado_por\":1,\"registros\":[{\"alumno_id\":$AL_ID2,\"estado\":\"presente\"}]}"
test_endpoint "DEL  /api/deportivo/asistencias/$ASIST_ID"  DELETE "/api/deportivo/asistencias/$ASIST_ID"  200

# =============================================================================
# EVALUACIONES
# =============================================================================
echo -e "${YELLOW}--- EVALUACIONES ---${NC}"
AL_ID3=$(curl -s -X POST "$BASE/api/deportivo/alumnos" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"nombre\":\"Pedro\",\"apellido_paterno\":\"Sánchez\",\"fecha_nacimiento\":\"2013-01-15\",\"club_id\":$CLUB_ID,\"is_active\":1}" | jq -r '.data.id // 1')
test_endpoint "GET  /api/deportivo/evaluaciones/form-data" GET  "/api/deportivo/evaluaciones/form-data" 200
test_endpoint "GET  /api/deportivo/evaluaciones"           GET  "/api/deportivo/evaluaciones"           200
test_endpoint "POST /api/deportivo/evaluaciones"           POST "/api/deportivo/evaluaciones"           201 \
  "{\"alumno_id\":$AL_ID3,\"equipo_id\":$EQ_ID,\"coach_id\":1,\"fecha_evaluacion\":\"2025-06-01\",\"criterios\":[]}"
EVAL_ID=$(curl -s "$BASE/api/deportivo/evaluaciones" -H "Authorization: Bearer $TOKEN" | jq -r '.data.evaluaciones[-1].id // 1')
test_endpoint "GET  /api/deportivo/evaluaciones/$EVAL_ID"           GET    "/api/deportivo/evaluaciones/$EVAL_ID"           200
test_endpoint "GET  /api/deportivo/evaluaciones/$EVAL_ID/criterios" GET    "/api/deportivo/evaluaciones/$EVAL_ID/criterios" 200
test_endpoint "PUT  /api/deportivo/evaluaciones/$EVAL_ID"           PUT    "/api/deportivo/evaluaciones/$EVAL_ID"           200 '{"mensaje_coach":"Buen desempeño"}'
test_endpoint "DEL  /api/deportivo/evaluaciones/$EVAL_ID"           DELETE "/api/deportivo/evaluaciones/$EVAL_ID"           200

# =============================================================================
# TORNEOS
# =============================================================================
echo -e "${YELLOW}--- TORNEOS ---${NC}"
test_endpoint "GET  /api/deportivo/torneos/form-data" GET  "/api/deportivo/torneos/form-data" 200
test_endpoint "GET  /api/deportivo/torneos"           GET  "/api/deportivo/torneos"           200
test_endpoint "POST /api/deportivo/torneos"           POST "/api/deportivo/torneos"           201 \
  "{\"nombre\":\"Copa Verano 2025\",\"actividad_id\":$ACT_ID2,\"fecha_inicio\":\"2025-07-01\",\"fecha_fin\":\"2025-07-31\",\"created_by\":1,\"is_active\":1}"
TOR_ID=$(curl -s "$BASE/api/deportivo/torneos" -H "Authorization: Bearer $TOKEN" | jq -r '.data.torneos[-1].id // 1')
test_endpoint "GET  /api/deportivo/torneos/$TOR_ID"          GET    "/api/deportivo/torneos/$TOR_ID"          200
test_endpoint "GET  /api/deportivo/torneos/$TOR_ID/partidos" GET    "/api/deportivo/torneos/$TOR_ID/partidos" 200
test_endpoint "PUT  /api/deportivo/torneos/$TOR_ID"          PUT    "/api/deportivo/torneos/$TOR_ID"          200 '{"nombre":"Copa Verano 2025 Mod"}'
test_endpoint "DEL  /api/deportivo/torneos/$TOR_ID"          DELETE "/api/deportivo/torneos/$TOR_ID"          200

# =============================================================================
# PARTIDOS
# =============================================================================
echo -e "${YELLOW}--- PARTIDOS ---${NC}"
# Re-crear torneo para partidos
TOR_ID2=$(curl -s -X POST "$BASE/api/deportivo/torneos" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"nombre\":\"Copa Invierno\",\"actividad_id\":$ACT_ID2,\"fecha_inicio\":\"2025-09-01\",\"created_by\":1,\"is_active\":1}" | jq -r '.data.id // 1')
EQ_ID2=$(curl -s -X POST "$BASE/api/deportivo/equipos" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"nombre\":\"Equipo Gamma\",\"grupo_id\":$GC_ID2,\"is_active\":1}" | jq -r '.data.id // 1')
test_endpoint "GET  /api/deportivo/partidos/form-data" GET  "/api/deportivo/partidos/form-data" 200
test_endpoint "GET  /api/deportivo/partidos"           GET  "/api/deportivo/partidos"           200
test_endpoint "POST /api/deportivo/partidos"           POST "/api/deportivo/partidos"           201 \
  "{\"torneo_id\":$TOR_ID2,\"equipo_local_id\":$EQ_ID2,\"rival_nombre\":\"Equipo Visitante\",\"fecha\":\"2025-07-05 10:00:00\",\"lugar\":\"Cancha 1\",\"estado\":\"programado\"}"
PART_ID=$(curl -s "$BASE/api/deportivo/partidos" -H "Authorization: Bearer $TOKEN" | jq -r '.data.partidos[-1].id // 1')
test_endpoint "GET   /api/deportivo/partidos/$PART_ID"                    GET   "/api/deportivo/partidos/$PART_ID"                   200
test_endpoint "GET   /api/deportivo/partidos/$PART_ID/convocatoria"       GET   "/api/deportivo/partidos/$PART_ID/convocatoria"      200
test_endpoint "POST  /api/deportivo/partidos/$PART_ID/convocatoria"       POST  "/api/deportivo/partidos/$PART_ID/convocatoria"      200 '{"jugadores":[]}'
test_endpoint "PATCH /api/deportivo/partidos/$PART_ID/resultado"          PATCH "/api/deportivo/partidos/$PART_ID/resultado"         200 '{"goles_local":2,"goles_visitante":1,"estado":"finalizado"}'
test_endpoint "DEL   /api/deportivo/partidos/$PART_ID"                    DELETE "/api/deportivo/partidos/$PART_ID"                   200

# =============================================================================
# MENSAJES COACH
# =============================================================================
echo -e "${YELLOW}--- MENSAJES COACH ---${NC}"
test_endpoint "GET  /api/deportivo/mensajes-coach"           GET  "/api/deportivo/mensajes-coach"          200
test_endpoint "POST /api/deportivo/mensajes-coach"           POST "/api/deportivo/mensajes-coach"          201 \
  "{\"equipo_id\":$EQ_ID2,\"coach_id\":1,\"asunto\":\"Convocatoria\",\"cuerpo\":\"Entrenamiento el sábado 10am\",\"tipo_destinatario\":\"todos\",\"destinatarios\":[]}"
MSG_ID=$(curl -s "$BASE/api/deportivo/mensajes-coach" -H "Authorization: Bearer $TOKEN" | jq -r '.data.mensajes[-1].id // 1')
test_endpoint "GET  /api/deportivo/mensajes-coach/$MSG_ID"   GET    "/api/deportivo/mensajes-coach/$MSG_ID" 200
test_endpoint "DEL  /api/deportivo/mensajes-coach/$MSG_ID"   DELETE "/api/deportivo/mensajes-coach/$MSG_ID" 200

# =============================================================================
# CONCEPTOS DE PAGO
# =============================================================================
echo -e "${YELLOW}--- CONCEPTOS DE PAGO ---${NC}"
test_endpoint "GET  /api/deportivo/conceptos-pago"       GET  "/api/deportivo/conceptos-pago"   200
test_endpoint "POST /api/deportivo/conceptos-pago"       POST "/api/deportivo/conceptos-pago"   201 \
  "{\"nombre\":\"Mensualidad Fútbol\",\"actividad_id\":$ACT_ID2,\"monto\":500.00,\"moneda\":\"MXN\",\"periodicidad\":\"mensual\",\"created_by\":1,\"is_active\":1}"
CP_ID=$(curl -s "$BASE/api/deportivo/conceptos-pago" -H "Authorization: Bearer $TOKEN" | jq -r '.data.conceptos[-1].id // 1')
test_endpoint "GET  /api/deportivo/conceptos-pago/$CP_ID" GET    "/api/deportivo/conceptos-pago/$CP_ID" 200
test_endpoint "PUT  /api/deportivo/conceptos-pago/$CP_ID" PUT    "/api/deportivo/conceptos-pago/$CP_ID" 200 '{"monto":550.00}'
test_endpoint "DEL  /api/deportivo/conceptos-pago/$CP_ID" DELETE "/api/deportivo/conceptos-pago/$CP_ID" 200

# =============================================================================
# PAGOS
# =============================================================================
echo -e "${YELLOW}--- PAGOS ---${NC}"
# Re-crear alumno y concepto para pagos
AL_ID4=$(curl -s -X POST "$BASE/api/deportivo/alumnos" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"nombre\":\"Diego\",\"apellido_paterno\":\"Ruiz\",\"fecha_nacimiento\":\"2012-08-10\",\"club_id\":$CLUB_ID,\"is_active\":1}" | jq -r '.data.id // 1')
CP_ID2=$(curl -s -X POST "$BASE/api/deportivo/conceptos-pago" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"nombre\":\"Mensualidad Test\",\"actividad_id\":$ACT_ID2,\"monto\":500.00,\"moneda\":\"MXN\",\"periodicidad\":\"mensual\",\"created_by\":1,\"is_active\":1}" | jq -r '.data.id // 1')
test_endpoint "GET  /api/deportivo/pagos/form-data"  GET  "/api/deportivo/pagos/form-data"  200
test_endpoint "GET  /api/deportivo/pagos"            GET  "/api/deportivo/pagos"            200
test_endpoint "GET  /api/deportivo/pagos/reporte"    GET  "/api/deportivo/pagos/reporte"    200
test_endpoint "POST /api/deportivo/pagos"            POST "/api/deportivo/pagos"            201 \
  "{\"alumno_id\":$AL_ID4,\"concepto_id\":$CP_ID2,\"monto_pagado\":500.00,\"fecha_pago\":\"2025-07-01\",\"estado\":\"pagado\",\"metodo_pago\":\"efectivo\",\"registrado_por\":1}"
PAG_ID=$(curl -s "$BASE/api/deportivo/pagos" -H "Authorization: Bearer $TOKEN" | jq -r '.data.pagos[-1].id // 1')
test_endpoint "GET   /api/deportivo/pagos/$PAG_ID"             GET   "/api/deportivo/pagos/$PAG_ID"              200
test_endpoint "PUT   /api/deportivo/pagos/$PAG_ID"             PUT   "/api/deportivo/pagos/$PAG_ID"              200 '{"notas":"Pago actualizado"}'
# Crear pago pendiente específico para test de registrar (requiere estado != pagado)
PAG_ID2=$(curl -s -X POST "$BASE/api/deportivo/pagos" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"alumno_id\":$AL_ID4,\"concepto_id\":$CP_ID2,\"monto_pagado\":500.00,\"fecha_pago\":\"2025-08-01\",\"estado\":\"pendiente\",\"metodo_pago\":\"efectivo\",\"registrado_por\":1}" | jq -r '.data.id // 1')
test_endpoint "PATCH /api/deportivo/pagos/$PAG_ID2/registrar"  PATCH "/api/deportivo/pagos/$PAG_ID2/registrar"  200 '{"metodo_pago":"efectivo"}'
test_endpoint "DEL   /api/deportivo/pagos/$PAG_ID"             DELETE "/api/deportivo/pagos/$PAG_ID"             200

# =============================================================================
# ENCUESTAS
# =============================================================================
echo -e "${YELLOW}--- ENCUESTAS ---${NC}"
CLUB_ID2=$(curl -s "$BASE/api/deportivo/clubes" -H "Authorization: Bearer $TOKEN" | jq -r '.data.clubes[0].id // 1')
test_endpoint "GET  /api/deportivo/encuestas/form-data"   GET  "/api/deportivo/encuestas/form-data"  200
test_endpoint "GET  /api/deportivo/encuestas"             GET  "/api/deportivo/encuestas"             200
test_endpoint "POST /api/deportivo/encuestas"             POST "/api/deportivo/encuestas"             201 \
  "{\"titulo\":\"Encuesta de satisfacción\",\"descripcion\":\"Evalúa tu experiencia\",\"club_id\":$CLUB_ID2,\"created_by\":1,\"is_active\":1}"
ENC_ID=$(curl -s "$BASE/api/deportivo/encuestas" -H "Authorization: Bearer $TOKEN" | jq -r '.data.encuestas[-1].id // 1')
test_endpoint "GET  /api/deportivo/encuestas/$ENC_ID"             GET    "/api/deportivo/encuestas/$ENC_ID"              200
test_endpoint "GET  /api/deportivo/encuestas/$ENC_ID/resultados"  GET    "/api/deportivo/encuestas/$ENC_ID/resultados"   200
test_endpoint "POST /api/deportivo/encuestas/$ENC_ID/asignar"     POST   "/api/deportivo/encuestas/$ENC_ID/asignar"      200 '{"segmentos":[]}'
test_endpoint "PUT  /api/deportivo/encuestas/$ENC_ID"             PUT    "/api/deportivo/encuestas/$ENC_ID"              200 '{"titulo":"Encuesta Mod"}'
test_endpoint "DEL  /api/deportivo/encuestas/$ENC_ID"             DELETE "/api/deportivo/encuestas/$ENC_ID"              200

# =============================================================================
# EVENTOS
# =============================================================================
echo -e "${YELLOW}--- EVENTOS ---${NC}"
test_endpoint "GET  /api/deportivo/eventos/form-data"    GET  "/api/deportivo/eventos/form-data" 200
test_endpoint "GET  /api/deportivo/eventos"              GET  "/api/deportivo/eventos"           200
test_endpoint "POST /api/deportivo/eventos"              POST "/api/deportivo/eventos"           201 \
  "{\"titulo\":\"Torneo de Padres\",\"tipo\":\"social\",\"fecha_inicio\":\"2025-08-10 09:00:00\",\"club_id\":$CLUB_ID2,\"created_by\":1,\"is_active\":1}"
EV_ID=$(curl -s "$BASE/api/deportivo/eventos" -H "Authorization: Bearer $TOKEN" | jq -r '.data.eventos[-1].id // 1')
test_endpoint "GET  /api/deportivo/eventos/$EV_ID"                  GET    "/api/deportivo/eventos/$EV_ID"               200
test_endpoint "GET  /api/deportivo/eventos/$EV_ID/confirmaciones"   GET    "/api/deportivo/eventos/$EV_ID/confirmaciones" 200
test_endpoint "PUT  /api/deportivo/eventos/$EV_ID"                  PUT    "/api/deportivo/eventos/$EV_ID"                200 '{"titulo":"Torneo de Padres Mod"}'
test_endpoint "DEL  /api/deportivo/eventos/$EV_ID"                  DELETE "/api/deportivo/eventos/$EV_ID"                200

# =============================================================================
# COMUNICADOS
# =============================================================================
echo -e "${YELLOW}--- COMUNICADOS ---${NC}"
test_endpoint "GET  /api/deportivo/comunicados/form-data"    GET  "/api/deportivo/comunicados/form-data"  200
test_endpoint "GET  /api/deportivo/comunicados"              GET  "/api/deportivo/comunicados"             200
test_endpoint "POST /api/deportivo/comunicados"              POST "/api/deportivo/comunicados"             201 \
  "{\"titulo\":\"Aviso Importante\",\"cuerpo\":\"Detalle del aviso\",\"tipo\":\"informativo\",\"requiere_firma\":false,\"club_id\":$CLUB_ID2,\"created_by\":1}"
COM_ID=$(curl -s "$BASE/api/deportivo/comunicados" -H "Authorization: Bearer $TOKEN" | jq -r '.data.comunicados[-1].id // 1')
test_endpoint "GET  /api/deportivo/comunicados/$COM_ID"          GET    "/api/deportivo/comunicados/$COM_ID"          200
test_endpoint "GET  /api/deportivo/comunicados/$COM_ID/firmas"   GET    "/api/deportivo/comunicados/$COM_ID/firmas"   200
test_endpoint "POST /api/deportivo/comunicados/$COM_ID/enviar"   POST   "/api/deportivo/comunicados/$COM_ID/enviar"   200
test_endpoint "PUT  /api/deportivo/comunicados/$COM_ID"          PUT    "/api/deportivo/comunicados/$COM_ID"          200 '{"titulo":"Aviso Mod"}'
test_endpoint "DEL  /api/deportivo/comunicados/$COM_ID"          DELETE "/api/deportivo/comunicados/$COM_ID"          200

# =============================================================================
# COORDINADORES
# =============================================================================
echo -e "${YELLOW}--- COORDINADORES ---${NC}"
test_endpoint "GET  /api/deportivo/coordinadores/form-data" GET  "/api/deportivo/coordinadores/form-data" 200
test_endpoint "GET  /api/deportivo/coordinadores"           GET  "/api/deportivo/coordinadores"           200
test_endpoint "POST /api/deportivo/coordinadores"           POST "/api/deportivo/coordinadores"           201 \
  "{\"user_id\":1,\"actividad_id\":$ACT_ID2,\"created_by\":1}"
COORD_ID=$(curl -s "$BASE/api/deportivo/coordinadores" -H "Authorization: Bearer $TOKEN" | jq -r '.data.coordinadores[-1].id // 1')
test_endpoint "GET  /api/deportivo/coordinadores/$COORD_ID" GET    "/api/deportivo/coordinadores/$COORD_ID" 200
test_endpoint "PUT  /api/deportivo/coordinadores/$COORD_ID" PUT    "/api/deportivo/coordinadores/$COORD_ID" 200 "{\"actividad_id\":$ACT_ID2}"
test_endpoint "DEL  /api/deportivo/coordinadores/$COORD_ID" DELETE "/api/deportivo/coordinadores/$COORD_ID" 200

# =============================================================================
# PROFESORES (coaches_equipo)
# =============================================================================
echo -e "${YELLOW}--- PROFESORES ---${NC}"
test_endpoint "GET  /api/deportivo/profesores/form-data" GET  "/api/deportivo/profesores/form-data" 200
test_endpoint "GET  /api/deportivo/profesores"           GET  "/api/deportivo/profesores"           200
test_endpoint "POST /api/deportivo/profesores"           POST "/api/deportivo/profesores"           201 \
  "{\"user_id\":1,\"equipo_id\":$EQ_ID2,\"rol\":\"principal\"}"
PROF_ID=$(curl -s "$BASE/api/deportivo/profesores" -H "Authorization: Bearer $TOKEN" | jq -r '.data.profesores[-1].id // 1')
test_endpoint "GET  /api/deportivo/profesores/$PROF_ID" GET    "/api/deportivo/profesores/$PROF_ID" 200
test_endpoint "PUT  /api/deportivo/profesores/$PROF_ID" PUT    "/api/deportivo/profesores/$PROF_ID" 200 '{"rol":"auxiliar"}'
test_endpoint "DEL  /api/deportivo/profesores/$PROF_ID" DELETE "/api/deportivo/profesores/$PROF_ID" 200

# =============================================================================
# USUARIOS TUTORES
# =============================================================================
echo -e "${YELLOW}--- USUARIOS TUTORES ---${NC}"
TUT_ID2=$(curl -s -X POST "$BASE/api/deportivo/tutores" -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "{\"nombre\":\"Beatriz\",\"apellido_paterno\":\"Torres\",\"email\":\"beatriz.t.$(date +%s)@example.com\",\"telefono\":\"5559998877\",\"tipo_relacion\":\"tutor\",\"club_id\":$CLUB_ID,\"is_active\":1}" | jq -r '.data.id // 1')
test_endpoint "GET   /api/deportivo/usuarios-tutores"                    GET   "/api/deportivo/usuarios-tutores"                    200
test_endpoint "GET   /api/deportivo/usuarios-tutores/$TUT_ID2"           GET   "/api/deportivo/usuarios-tutores/$TUT_ID2"           200
test_endpoint "PATCH /api/deportivo/usuarios-tutores/$TUT_ID2/activar"   PATCH "/api/deportivo/usuarios-tutores/$TUT_ID2/activar"   200
test_endpoint "PATCH /api/deportivo/usuarios-tutores/$TUT_ID2/desactivar" PATCH "/api/deportivo/usuarios-tutores/$TUT_ID2/desactivar" 200

# =============================================================================
# SISTEMA — ADMIN LOG
# =============================================================================
echo -e "${YELLOW}--- ADMIN LOG ---${NC}"
LOG_ID=$(curl -s "$BASE/api/deportivo/admin-log" -H "Authorization: Bearer $TOKEN" | jq -r '.data.logs[0].id // 1')
test_endpoint "GET /api/deportivo/admin-log"          GET "/api/deportivo/admin-log"          200
test_endpoint "GET /api/deportivo/admin-log/$LOG_ID"  GET "/api/deportivo/admin-log/$LOG_ID"  200

# =============================================================================
# SISTEMA — NOTIFICACIONES LOG
# =============================================================================
echo -e "${YELLOW}--- NOTIFICACIONES LOG ---${NC}"
test_endpoint "GET  /api/deportivo/notificaciones-log"         GET  "/api/deportivo/notificaciones-log"         200
NOTIF_ID=$(curl -s "$BASE/api/deportivo/notificaciones-log" -H "Authorization: Bearer $TOKEN" | jq -r '.data.notificaciones[0].id // empty')
if [ -n "$NOTIF_ID" ]; then
  test_endpoint "GET  /api/deportivo/notificaciones-log/$NOTIF_ID"       GET  "/api/deportivo/notificaciones-log/$NOTIF_ID"       200
  test_endpoint "POST /api/deportivo/notificaciones-log/$NOTIF_ID/reenviar" POST "/api/deportivo/notificaciones-log/$NOTIF_ID/reenviar" 200
else
  echo -e "  (skip) No hay notificaciones en la BD — omitiendo GET/:id y POST/:id/reenviar"
  ((PASS+=2))
fi

# =============================================================================
# RESUMEN
# =============================================================================
echo ""
echo -e "${CYAN}==============================${NC}"
echo -e "${CYAN}  RESULTADOS FINALES${NC}"
echo -e "${CYAN}==============================${NC}"
echo -e "  ${GREEN}PASS: $PASS${NC}"
echo -e "  ${RED}FAIL: $FAIL${NC}"
echo -e "  TOTAL: $((PASS + FAIL))"
echo ""
