#!/bin/bash
set -e

echo "🔧 Resolviendo conflictos de Git..."

# 1. Deshabilitar GPG signing
echo "1️⃣ Deshabilitando GPG signing..."
git config --local commit.gpgsign false

# 2. Resolver conflictos tomando versión local de index.html
echo "2️⃣ Resolviendo conflictos..."
if [ -f index.html ]; then
    git checkout --ours index.html
    git add index.html
fi

# 3. Regenerar package-lock.json
echo "3️⃣ Regenerando package-lock.json..."
if [ -f package-lock.json ]; then
    git rm package-lock.json || true
    npm install
    git add package-lock.json
fi

# 4. Añadir scripts de utilidad
echo "4️⃣ Añadiendo scripts de utilidad..."
git add deploy.sh backup.sh sync.sh setup-mechmind.sh token-manager.sh

# 5. Verificar estado
echo "5️⃣ Estado actual:"
git status

# 6. Hacer commit de resolución
echo "6️⃣ Haciendo commit..."
git commit -m "🔧 Fix: Resolve merge conflicts and add utility scripts" || echo "Nothing to commit"

# 7. Sincronizar con remoto
echo "7️⃣ Sincronizando con remoto..."
git fetch origin
git pull origin main --rebase || {
    echo "⚠️ Conflictos durante pull. Resolviendo automáticamente..."
    git checkout --ours index.html
    git add index.html
    git rebase --continue
}

# 8. Push final
echo "8️⃣ Subiendo cambios..."
git push origin main

echo "✅ ¡Conflictos resueltos y cambios subidos!"
