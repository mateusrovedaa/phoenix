#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# Phoenix Upgrade Script - Versão Única
# ═══════════════════════════════════════════════════════════════════════════
# 
# Este script clona uma nova versão do Phoenix e aplica todas as customizações
# automaticamente. Patches são aplicados em ordem sequencial.
#
# Uso:
#   ./upgrade.sh [versão] [--force]
#
# Exemplos:
#   ./upgrade.sh main           # Atualiza para main branch
#   ./upgrade.sh v4.0.0         # Atualiza para tag específica
#   ./upgrade.sh main --force   # Força sobrescrita de upgrade anterior
#
# ═══════════════════════════════════════════════════════════════════════════

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"
PATCHES_DIR="$ROOT_DIR/patches"
FILES_DIR="$ROOT_DIR/files"

PHOENIX_VERSION="${1:-main}"
FORCE="${2:-}"
UPSTREAM_URL="https://github.com/Arize-ai/phoenix.git"
WORK_DIR="$ROOT_DIR/phoenix-upgraded"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🚀 Phoenix Custom Upgrade Script${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo ""
    echo "  Versão alvo: $PHOENIX_VERSION"
    echo "  Diretório:   $WORK_DIR"
    echo ""
}

print_step() {
    echo -e "${GREEN}▶ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════
# Main Script
# ═══════════════════════════════════════════════════════════════════════════

print_header

# 1. Verificar/limpar diretório de trabalho
if [ -d "$WORK_DIR" ]; then
    if [ "$FORCE" = "--force" ]; then
        print_warning "Removendo diretório existente..."
        rm -rf "$WORK_DIR"
    else
        print_error "Diretório $WORK_DIR já existe."
        echo "   Use --force para sobrescrever."
        exit 1
    fi
fi

# 2. Clonar Phoenix do upstream
print_step "Clonando Phoenix $PHOENIX_VERSION do upstream..."
git clone --depth 1 --branch "$PHOENIX_VERSION" "$UPSTREAM_URL" "$WORK_DIR" 2>&1 | tail -3

cd "$WORK_DIR"

# 3. Aplicar patches sequenciais
echo ""
print_step "Aplicando patches de customização..."

SUCCESS_COUNT=0
FAILED_COUNT=0
FAILED_PATCHES=""

for patch in "$PATCHES_DIR"/*.patch; do
    if [ -f "$patch" ]; then
        patch_name=$(basename "$patch")
        
        if git apply --check "$patch" 2>/dev/null; then
            git apply "$patch"
            print_success "$patch_name"
            ((SUCCESS_COUNT++))
        elif git apply --3way "$patch" 2>/dev/null; then
            print_warning "$patch_name (3-way merge)"
            ((SUCCESS_COUNT++))
        else
            print_error "$patch_name (CONFLITO)"
            FAILED_PATCHES="$FAILED_PATCHES\n   - $patch_name"
            ((FAILED_COUNT++))
        fi
    fi
done

# 5. Relatório final
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  📊 Resultado${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""
echo "  ✅ Patches aplicados: $SUCCESS_COUNT"
echo "  ❌ Conflitos: $FAILED_COUNT"

if [ $FAILED_COUNT -gt 0 ]; then
    echo ""
    echo "  Patches com conflito:"
    echo -e "$FAILED_PATCHES"
    echo ""
    print_warning "Resolva os conflitos manualmente ou use IA para assistência."
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  🎉 Próximos Passos${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""
echo "  1. cd $WORK_DIR"
echo "  2. docker compose build"
echo "  3. docker compose up -d"
echo "  4. Testar: http://localhost:6006"
echo ""

if [ $FAILED_COUNT -gt 0 ]; then
    exit 1
fi

exit 0
